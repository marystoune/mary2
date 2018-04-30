namespace :awards do
  
  desc "Sends the bonuses (qiwicoins) to the users if they are pending it"
  task :send_pending_bonuses => :environment do
    
  	bonuses = Bonus.where("is_sended = ? AND status = ?", false, 'approved')

  	bonuses.each do |bonus|
  	  if Qiwicoin::Client.instance.get_balance >= bonus.amount && bonus.address.present?
  	    bonus.qc_tx_id  = Qiwicoin::Client.instance.send_to_address(bonus.address, bonus.amount.to_f)
  	    bonus.is_sended = true
        bonus.status = 'paid'
  	    bonus.save
  	  end
  	end

  end

  desc "Sends the referrer payments (qiwicoins) to the users if they are pending it"
  task :send_pending_referrer_payments => :environment do
    
    referrer_payments = ReferrerPayment.where(is_sended: false)

    referrer_payments.each do |payment|
      if Qiwicoin::Client.instance.get_balance >= payment.amount && payment.address.present?
        payment.qc_tx_id  = Qiwicoin::Client.instance.send_to_address(payment.address, payment.amount.to_f)
        payment.is_sended = true
        payment.save
      end
    end

  end

end
