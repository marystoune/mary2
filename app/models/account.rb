class Account < ActiveRecord::Base
	
	has_one  :message
	has_one  :bonus
  has_many :referrer_payments

  has_many :email_to_admins
  
  apply_simple_captcha
  def id_label
    id.to_s
  end 

  def check_for_ip_address(ip)
  #    raise sign_up_ip_address
    if Account.where("current_sign_in_ip = ? or last_sign_in_ip = ?", ip, ip).size > 0
       return true
  #      errors.add(:base, "Sorry, service is currently not available. Please try again later.")
    end
  end

  def to_label 
    email
  end
end
