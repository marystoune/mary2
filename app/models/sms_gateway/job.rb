module SmsGateway
	class Job
		
		def self.send_message(profile)
			sms = SmsGateway::Sms.new(profile)
			sms.deliver

			sms.reply = Hash.from_xml(sms.reply)

			msg = profile.message
			msg = profile.build_message unless msg
			msg.code = sms.text

			if sms.reply['ExpertTextAPI']['Status'] == "SUCCESS"
				msg.is_sended = true
				msg.message_id = sms.reply['ExpertTextAPI']['MsgId']
			end

			msg.save

			if msg.is_sended
				[:notice, I18n.t("successes.sms_gateway")]
			else
				[:alert,  I18n.t("errors.sms_gateway")]
			end
		end

		def self.query_balance
			balance = SmsGateway::Balance.new
			balance.query

			balance.reply = Hash.from_xml(balance.reply)
		end

	end
end
