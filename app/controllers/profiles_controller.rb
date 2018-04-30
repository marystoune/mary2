class ProfilesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :define_profile

	def show
		
	end

	def referral
		
	end

	def send_sms
		@profile.validate_country(params[:country])
		@profile.validate_phone_number(params[:phone_number], params[:country])

		if @profile.is_valid?
			@profile.country      = params[:country]
			@profile.phone_number = Phony.normalize(params[:phone_number])
			@profile.save

			result = SmsGateway::Job.send_message(@profile)
			@profile.phone_number = params[:phone_number]
			@profile.save(validate: false)
			flash[result.first] = result.last
		else
			flash[:alert] = @profile.errors.full_messages
		end

		redirect_to profile_path
	end

	def sms_verification
		sms_code = params[:sms_code]

		if !@profile.qwc_address_external
			flash[:alert] = I18n.t("errors.before_verify")
		elsif sms_code.blank?
			flash[:alert] = I18n.t("errors.verify_sms_blank")
		else
			@profile.verify!(sms_code)
			
			if @profile.is_verified
				@profile.send_bonus!
				@profile.make_referrer_payment!
				flash[:notice] = I18n.t("successes.verify_sms_success")
			else
				flash[:alert]  = I18n.t("errors.verify_sms_incorrect")
			end
		end

		redirect_to profile_path
	end

	def qiwicoin_address
#		@profile.validate_address(params[:qwc_address_external])
#		@profile.qwc_address_external = params[:qwc_address_external]
#		@profile.update_attributes 
		user_params.each do |  value |
			@profile.send(value[0] + "=", value[1])
		end

		if @profile.save
			flash[:notice] = "Your Profile was successfully saved"
			redirect_to profile_path
		else
			flash[:alert] = @profile.errors.full_messages
			@first_name = @profile.first_name
			@last_name = @profile.last_name
			@country = @profile.country
			@address = @profile.qwc_address_external
			@profile.first_name = @profile.last_name = @profile.country = @profile.qwc_address_external = nil
			render 'show'
		end
		
	end

	private
		def define_profile
			@profile = Profile.find(current_user)
		end

		def user_params
		  params.require(:user).permit(:last_name, :first_name, :country, :phone_number, :qwc_address_external)
		end


end
