class AddVerificationAttemptsToMessages < ActiveRecord::Migration
  def change
  	rename_column :messages, :attempt_count, :sending_attempts
  	add_column :messages, :verification_attempts, :integer, default: 0, after: :sending_attempts
  end
end
