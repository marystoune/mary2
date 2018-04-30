class Referral < ActiveRecord::Base

	class << self
		
		def add_referral(referrer_id, referral_id)
			parent_ref = Referral.where(referral_id: referrer_id).first
			parent_referrer_id = parent_ref.referrer_id if parent_ref
			
			Referral.new do |ref|
		    ref.referrer_id = referrer_id
		    ref.referral_id = referral_id
		    ref.parent_referrer_id = parent_referrer_id
		    ref.save
	  	end
		end

		def get_referral_bonus(user, bonus_setting)
			config = YAML::load(File.open(File.join(Rails.root, "config", "referral.yml")))[Rails.env]

	    referral_bonus = 0
	    referral = Referral.where(referral_id: user.id).first
	    referral_bonus = bonus_setting.amount * config['referal_award'].to_f/100 if referral

	    return referral_bonus
		end

		def make_referrer_payment(user)
			config = YAML::load(File.open(File.join(Rails.root, "config", "referral.yml")))[Rails.env]

			referral = Referral.where(referral_id: user.id).first
			referrer_payments = []

			if referral && referral.referrer_id
				referrer_payments << ReferrerPayment.new do |rp|
					rp.account_id = referral.referrer_id
					rp.amount = config['referer_award'].to_f
					rp.address = user.qwc_address_external
					rp.save
				end
			end

			if referral && referral.parent_referrer_id
				referrer_payments << ReferrerPayment.new do |rp|
					rp.account_id = referral.parent_referrer_id
					rp.amount = config['parent_referrer_award'].to_f
					rp.address = user.qwc_address_external
					rp.save
				end
			end

			referrer_payments.each do |payment|
		    if Qiwicoin::Client.instance.get_balance >= payment.amount && payment.address.present?
		      payment.qc_tx_id  = Qiwicoin::Client.instance.send_to_address(payment.address, payment.amount.to_f)
		      payment.is_sended = true
		      payment.save
		    end
	  	end
		end
	
	end

end
