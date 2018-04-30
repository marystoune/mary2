class Message < ActiveRecord::Base

	belongs_to :account

	before_save :increase_attempts_count

	protected
		def increase_attempts_count
			self.sending_attempts += 1
		end

end
