require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Qiwicoin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

@email_config = YAML::load(File.read(File.join(Rails.root, "config", "mail.yml")))[Rails.env]

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address              => @email_config['address'],
  :port                 => @email_config['port'],
  :domain               => @email_config['domain'],
  :user_name            => @email_config['user_name'],
  :password             => @email_config['password'],
  :authentication       => @email_config['authentication'],
  #:tls => @email_config['enable_starttls_auto'] 
  #:enable_starttls_auto => @email_config['enable_starttls_auto'] 
  }

if @email_config['enable_starttls_auto'] == 'true'
  ActionMailer::Base.smtp_settings['tls'] = true
end


config.action_mailer.default_url_options = { host: "https://www.qiwicoin.org" }

=begin
    config.action_mailer.default_url_options = { host: Settings.mailer.host }

    if Settings.mailer.service == 'smtp'
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.raise_delivery_errors = false

      config.action_mailer.smtp_settings = {
        address: Settings.mailer.smtp.address,
        domain:  Settings.mailer.smtp.domain,
        port:    Settings.mailer.smtp.port,

        user_name: Settings.mailer.smtp.email,
        password:  Settings.mailer.smtp.password,

        authentication: Settings.mailer.smtp.authentication,
        #enable_starttls_auto: Settings.mailer.enable_starttls_auto
        #tls: Settings.mailer.enable_starttls_auto
      }
      if @email_config['enable_starttls_auto'] == 'true'
        config.action_mailer.smtp_settings['tls'] = true
      end
      
    elsif Settings.mailer.service == 'sandmail'
      config.action_mailer.raise_delivery_errors = true

      config.action_mailer.sendmail_settings = {
        location:  Settings.mailer.sandmail.location,
        arguments: Settings.mailer.sandmail.arguments
      }
    else
      config.action_mailer.delivery_method = :test
      config.action_mailer.raise_delivery_errors = false
    end
=end

    config.autoload_paths << File.join(config.root, 'lib')

    config.autoload_paths << File.join(config.root, 'config/initializers/')
    config.autoload_paths << File.join(config.root, 'lib', 'validators')
    config.assets.precompile << /\.(?:svg|eot|woff|ttf|otf)\z/
  end
end
