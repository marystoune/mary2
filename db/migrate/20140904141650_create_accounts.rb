class CreateAccounts < ActiveRecord::Migration
  def self.up
    rename_table :users, :accounts
    add_column :accounts, :type, :string, after: 'encrypted_password'
  end

  def self.down
  	remove_column :accounts, :type
  	rename_table :accounts, :users
  end
end
