class DeviseSessionsController < Devise::SessionsController
  skip_before_filter :confirmed_session_required, :only => [:destroy]
  
  def new
    super
  end
  
  def create
    super
  end
  
  def destroy
    @current_session.finish!
    super  
  end
  
 
end
