module SmsGateway
	class Balance
		
		attr_accessor :reply

		def initialize
			@reply    = nil
		end

		def query
			SmsGateway::Base.query(self)
		end

	end
end
