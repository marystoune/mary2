class SessionsController < ApplicationController
  skip_before_filter :session_required, :only => [:new, :track, :create, :finish, :logout, :two_factor]
  skip_before_filter :confirmed_session_required
  
  def new
    reset_session
    @session = LoginSession.new
  end
  
  def create
    reset_session
    @session = LoginSession.new(params[:session])
    if @session.authentic?
      session[:user_id] = @session.user.id
      redirect_to :track_authenticator, :notice => "Welcome back"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  def finish
    current_session.finish! if current_session
    @current_session = nil
    reset_session
    redirect_to :root, :notice => "Logged out!"
  end
  
  def destroy
    @session.destroy
    redirect_to :root
  end
  
  def track
    LoginSession.perform_housekeeping
    
    # assign a new id for this client if it isn't recognised
    client_id = cookies.signed[:_client_id] ||= UUIDTools::UUID.timestamp_create.to_s
    if current_user
      @session = LoginSession.find_or_initialize_by_user_id_and_client_id(current_user.id, client_id)
    else
      @session = LoginSession.new
    end
    
    
    # check if we have already authenticated this session
    redirect_to params[:next] || :root and return if @session == current_session
    
    @session.update_attributes(
      :ip_address => request.remote_ip,
      :user_agent => request.user_agent,
      :client_id =>  client_id,
      :login_count => @session.login_count + 1,
      :authenticated_at => Time.now.utc,
      :finished_at => nil
    )
    
    # sign up session is trusted
    @session.confirm! if session[:first_visit]
    
    session[:user_session_id] = @session.id
    
    # remember this client
    cookies.permanent.signed[:_client_id] = {
      :value => @session.client_id, 
      :secure => Rails.env.production? ? true : false,
      :httponly => true
    }
    
    @session.send_confirmation_code unless @session.confirmed?
    
    flash.keep # pass on any flash messages
    redirect_to params[:next] || :root
  end
  
  def confirm
  end

  def two_factor
    @login_session = LoginSession.where("user_id = ?", current_user.id)
    @login_session.update_all("enable_two_factor = #{params[:login_session][:enable_two_factor]}")
    
    redirect_to account_path,
      :notice => "Your profile has been updated successfuly"
  end

  def validate
    @session.validation_code = params[:login_session][:validation_code].strip
    
    if @session == current_session and @session.validates?
      @session.confirm!
      redirect_to :root, :notice => 'This device is now validated'
    else
      @session.increment! :confirmation_failure_count
      if @session.too_many_failures?
        @session.send_confirmation_code
        flash[:alert] = "Too many validation failures. We've sent you another code."
      end
      redirect_to :action => :confirm
    end
  end
  
  def resend
    @session.send_confirmation_code
    flash[:notice] = 'A new code has been sent.'
    redirect_to :action => :confirm
  end
  
  def logout
    render :text => 'Log out'
  end
  
  private
    def session_required
      #@session = current_user.login_sessions.find_by_id(params[:id])
      @session = LoginSession.find_by_id(params[:id])
      redirect_to :root unless @session
    end
end
