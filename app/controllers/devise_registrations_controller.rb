class DeviseRegistrationsController < Devise::RegistrationsController
  
  def create
    build_resource(sign_up_params)
    resource.captcha_checked! if simple_captcha_valid?
    #resource.ip_address_checked! if resource.ip_address_valid?(request.remote_ip)
    is_invalid_ip = resource.check_for_ip_address(request.remote_ip)
    resource.current_sign_in_ip = request.remote_ip
    
    resource_saved = resource.save
    yield resource if block_given?

    if !is_invalid_ip && resource_saved
      resource.add_referral!(params[:invitation_token].strip)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      flash.now[:alert] = resource.errors.full_messages
      flash.now[:alert] = "Sorry, service is currently not available. Please try again later." if is_invalid_ip
      render :new
    end
  end

  private
 
  def sign_up_params
    params.require(:user).permit(:phone_number, :country, :first_name, :last_name, :email, :password, :password_confirmation)
  end

end
