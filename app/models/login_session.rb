class LoginSession < ActiveRecord::Base
  attr_accessor :email, :password, :validation_code
  
  validates_uniqueness_of :client_id, :scope => :user_id
  belongs_to :user
  default_scope :order => 'authenticated_at DESC'
  
  scope :confirmed, where('client_confirmed_at IS NOT NULL')
  scope :expired, lambda { confirmed.where("client_confirmed_at < ?", Time.zone.now - 30.days) }  
  
  def authentic?
    user = User.find_by_email(self.email)
    if user && user.authenticate(self.password)
      self.password = nil
      self.user = user
      return self
    end
    self.password = nil
    return false
  end
  
  def confirmed?
    !self.client_confirmed_at.nil?
  end
  
  def confirm!
    update_attribute :client_confirmed_at, Time.now.utc
  end
  
  def finish!
    update_attribute :finished_at, Time.now.utc
  end
  
  def too_many_failures?
    self.confirmation_failure_count >= 3
  end
  
  def validates?
    return true if self.validation_code == ROTP::TOTP.new(self.user.auth_secret).now.to_s
    return false if self.unique_key_generated_at < (Time.now.utc - 10.minutes)
    return self.validation_code == self.unique_key
  end
  
  def send_confirmation_code
    assign_unique_key!
    self.update_attribute :confirmation_failure_count, 0

    UserMailer.session_confirmation(self).deliver
  end
  
  def device
    case self.user_agent
      when /Macintosh/ then 'Mac'
      when /Windows/ then 'Windows'
      when /iPhone/ then 'iPhone'
      when /iPad/ then 'iPad'
      when /Android/ then 'Android'
      else 'unknown'
    end
  end
  
  def browser
    case self.user_agent
      when /Chrome/ then 'Chrome'
      when /Firefox/ then 'Firefox'
      when /Safari/ then 'Safari'
      when /MSIE/ then 'IE'
      when /Opera/ then 'Opera'
      else 'unknown'
    end
  end
  
  def self.perform_housekeeping
    # invalidate any expired sessions (30 days old)
    self.expired.update_all :client_confirmed_at => nil
  end
  
  private
    def assign_unique_key!
      assign_unique_key
      self.save!
    end
    
    # Assigns a time-sensitive random validation key
    def assign_unique_key
      # generate zero padded random 5 digits
      self.unique_key = SecureRandom.random_number(10 ** 5).to_s.rjust(5,'0')
      self.unique_key_generated_at = Time.now.utc
    end
end