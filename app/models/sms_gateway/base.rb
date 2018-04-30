module SmsGateway
	class Base

		class << self
			def deliver(sms)
				self.send_sms(sms)
			end

			def query(balance)
				self.query_balance(balance)
			end

			def send_sms(sms)
				config = YAML::load(File.read(File.join(Rails.root, "config", "sms_gateway.yml")))[Rails.env]
			  
			  params = {
      		"USERID" => config["user_id"],
      		"PWD"    => config["password"],
      		"APIKEY" => config["api_key"],
					"FROM"   => config["from"],
					"TO"     => sms.to_phone,
					"MSG"    => "Verification Code is #{sms.text}"
			  }

			  sms.reply = self.make_request(config["api_uri"] + "/SendSMS", params)
			end

			def query_balance(balance)
				config = YAML::load(File.read(File.join(Rails.root, "config", "sms_gateway.yml")))[Rails.env]
			  
			  params = {
      		"USERID" => config["user_id"],
      		"PWD"    => config["password"],
      		"APIKEY" => config["api_key"]
			  }

			  balance.reply = self.make_request(config["api_uri"] + "/QueryBalance", params)
			end

			def make_request(uri, params)
				uri = URI.parse(uri)
    		http = Net::HTTP.new(uri.host, uri.port)
    		http.use_ssl = uri.scheme == 'https'
    		request = Net::HTTP::Post.new(uri.request_uri)
    		request.set_form_data(params)
        
    		response = http.request(request)
    		response.read_body
			end
		end

	end
end
