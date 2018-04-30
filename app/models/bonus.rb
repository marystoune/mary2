class Bonus < ActiveRecord::Base

	belongs_to :account

#	delegate :email, to: :account
#	delegate :last_name, to: :account

	validates :address,
						presence: true,
						qiwicoin_address: true,
						not_mine_address: true

	def email
		account ? account.email : ""
	end

	def last_name
		account ? account.last_name : ""
	end

  def account_id_active_scaffold
    account ? account.id : "-"
  end

  def update_child_bonuses(status)
    Referral.where(parent_referrer_id: account_id).all.each do |ref|
      bonus_referal =  Bonus.find_by_account_id(ref.referral_id)
      bonus_referral.update_attribute(:status, status)
      bonus_referrer = Bonus.find_by_account_id(ref.referrer_id)
      bonus_referer.update_attribute(:status, status)
    end
  end

	class << self
    def bonus_descrption
      users_amount = Account.all.size
      current_bonus_setting = BonusSetting.where("begin <= ? AND end >= ?", users_amount, users_amount).first
      current_bonus_setting ? current_bonus_setting.amount.to_f : nil
    end

		
		def send_bonus(user)
  	  bonus_setting = BonusSetting.where("begin <= :user_id AND end >= :user_id", {user_id: user.id}).first
	
  	  if bonus_setting
  	    bonus = user.bonus
  	    bonus = user.build_bonus unless bonus
      
        referral_bonus = Referral.get_referral_bonus(user, bonus_setting)
  	    bonus.amount  = bonus_setting.amount + referral_bonus
  	    bonus.address = user.qwc_address_external
        bonus.status = 'pending'

  	    bonus.save
  	  end
		end
	
	end

  # Sets a description of a record in the admin tools.
  def to_label
    "#{I18n.t("activerecord.models.bonus.one")} n° #{id}"
  end

end
