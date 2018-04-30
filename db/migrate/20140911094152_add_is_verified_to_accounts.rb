class AddIsVerifiedToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :is_verified, :boolean, default: false, after: :country
  end
end
