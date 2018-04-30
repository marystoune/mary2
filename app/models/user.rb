class User < Account


  TIME_TO_BAN_FOR_USER_TO_CONTACT_US = 2

  def is_banned_for_send_email_to_admin?
   # last_user_email = email_to_admins.last
   # last_user_email && Time.now.min - last_user_email.created_at.time.min < TIME_TO_BAN_FOR_USER_TO_CONTACT_US
   false
  end


  apply_simple_captcha
  
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, 
  			 :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable,
         :lockable,
         :confirmable,
         :timeoutable

  before_validation :assign_auth_secret,
    :on => :create

  before_save :normalize_phone_number
  
  before_create :assign_role

  validate :captcha do
    if captcha.nil? and new_record?
      errors[:captcha] << I18n.t("errors.answer_incorrect")
    end
  end

  #validate :ip_address do
  #  if ip_address.nil? and new_record?
  #    errors[:ip_address] << I18n.t("errors.service_not_available")
  #  end
  #end

  def captcha
    @captcha
  end

  def captcha_checked!
    @captcha = true
  end
  
  #def ip_address
  #  @ip_address
  #end

  #def ip_address_checked!
  #  @ip_address = true
  #end

  #def ip_address_valid?(ip)
  #  Account.where("current_sign_in_ip = ? or last_sign_in_ip = ?", ip, ip).count.zero?
  #end

  def add_referral!(referrer_id)
    if referrer_id.present?
      Referral.add_referral(referrer_id, self.id)
    end
  end

  # Sets a description of a record in the admin tools.
  def to_label
    "#{I18n.t("activerecord.models.user.one")} (#{email})"
  end

  def is_admin?
    role == 'admin'
  end

  protected
  
    def assign_auth_secret
      self.auth_secret = ROTP::Base32.random_base32
    end

    def normalize_phone_number
      self.phone_number = if self.phone_number.blank? 
                            nil
                          else
                            Phony.normalize(self.phone_number)
                          end
    end

    def assign_role
      self.role = 'user'
    end

end
