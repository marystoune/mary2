namespace :admin_email do
  
  task send: :environment do
    last_message = ::EmailToAdmin.where("is_sent = ?", 0).last
    if last_message
      UserMailer.send_message_to_admin(last_message).deliver
      last_message.is_sent = true
      last_message.save!
    end
  end

end
