#@email_config = YAML::load(File.read(File.join(Rails.root, "config", "mail.yml")))[Rails.env]
#
#ActionMailer::Base.delivery_method = :smtp
#
#ActionMailer::Base.smtp_settings = {
#  :address              => @email_config['address'],
#  :port                 => @email_config['port'],
#  :domain               => @email_config['domain'],
#  :user_name            => @email_config['user_name'],
#  :password             => @email_config['password'],
#  :authentication       => @email_config['authentication'],
#  :enable_starttls_auto => @email_config['enable_starttls_auto'] 
#  }
#
ADMIN_EMAIL = "admin@qiwicoin.org"

class UserMailer < ActionMailer::Base
  default from: "QiwiCoin <no-reply@qiwicoin.org>"

  def session_confirmation(session)
    @session = session
    user = @session.user
    
    mail to: user.email,
      subject: 'Pin code to access your account'#, from: "QiwiCoin <no-reply@qiwicoin.org>"
  end

  def send_message_to_admin(message)
    @message = message
    mail to: ADMIN_EMAIL, subject: message.subject
  end
  
end
