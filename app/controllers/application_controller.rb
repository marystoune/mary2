class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  helper :all
  
  include ApplicationHelper

  helper_method :current_session
  before_filter :session_required
  before_filter :confirmed_session_required



  private

    def current_session
      @current_session ||= LoginSession.find_by_id(session[:user_session_id])
      session[:user_session_id] = nil unless @current_session
      @current_session
    end

    def session_required
      if current_user
        redirect_to '/auth/track' unless current_session
      end      
    end
    
    def confirmed_session_required
      if current_user
        redirect_to confirm_auth_url(current_session), 
        :alert => "This device is not recognised" unless current_session.confirmed?
      end      
    end

end
