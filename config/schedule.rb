job_type :rake, "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every 1.minutes do
  rake "qiwicoin:synchronize_blockchain"
end

every 24.hours do 
	rake "awards:send_pending_bonuses"
end

every 24.hours do 
	rake "awards:send_pending_referrer_payments"
end


every 1.minutes do
  rake "admin_email:send"
end
