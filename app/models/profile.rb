class Profile < Account

  VALID_NAME_REGEX = /\A\D+\z/i
  
  SMS_CODE_LENGTH = 4

   validates_uniqueness_of :qwc_address_external

  validates :first_name, :last_name,
    presence: true,
    format: { with: VALID_NAME_REGEX }
  validates :country,
    presence: true,
    inclusion: { in: Country.all.map { |c| c[0]} }

  validates :phone_number,
    phone: true

  validates :qwc_address_external, presence: true

  validate :validate_address



  def validate_address
    if !Qiwicoin::Util.valid_qiwicoin_address?(qwc_address_external) or Qiwicoin::Util.my_qiwicoin_address?(qwc_address_external)
      errors[:qwc_address_external] << (I18n.t "errors.invalid")
    else
      keys_tmp = qwc_address_external.split(':')
      if Profile.where("qwc_address_external LIKE ? or qwc_address_external LIKE ?", "%#{keys_tmp[0]}%", "%#{keys_tmp[1]}%").first
        errors[:base] << "You have already received your bonus"
      end
    end
  end

  def validate_country(country)
    if country.blank?
      errors[:country] << "can't be blank"
    end
    unless Country.all.map { |c| c[0]}.include?(country)
      errors[:country] << "is not included in the list"
    end
  end

  def validate_phone_number(phone_number, country)
    cc = Country.find_country_by_name(country).country_code
    
    if phone_number.blank? || !Phony.plausible?("+" + cc  + phone_number, cc: cc) || Profile.where("phone_number = ?", phone_number).first
      errors[:phone_number] << (I18n.t "errors.invalid_phone_number", country: country)
    end
  end

  def is_valid?
    errors.empty?
  end

  def send_bonus!
    Bonus.send_bonus(self)
  end

  def make_referrer_payment!
    Referral.make_referrer_payment(self)
  end

  def generate_sms_code!
    o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    (0...SMS_CODE_LENGTH).map { o[rand(o.size)] }.join.upcase
  end

  def verify!(sms_code)
    msg = self.message
    
    if msg && msg.is_sended && msg.code == sms_code.strip.upcase
      update_attribute(:is_verified, true)
    end
  end

end
