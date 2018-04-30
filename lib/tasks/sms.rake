namespace :sms do
  
  desc "Sets the number of attempts to verify the user's mobile number to zero"
  task :reset_sms_verification_attempts => :environment do

    locked_messages = Message.where(verification_attempts: Profile::VERIFICATION_LIMIT)

    locked_messages.each do |msg|
      msg.update_attribute(:verification_attempts, 0)
    end

  end

end
