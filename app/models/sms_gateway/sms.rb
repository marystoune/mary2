module SmsGateway
	class Sms
		
		attr_accessor :reply
		attr_reader   :to_phone, :text

		def initialize(profile)
			@to_phone = Country.find_country_by_name(profile.country).country_code + profile.phone_number
#			raise @to_phone
			@text     = profile.generate_sms_code!
			@reply    = nil
		end

		def deliver
			SmsGateway::Base.deliver(self)
		end

	end
end
