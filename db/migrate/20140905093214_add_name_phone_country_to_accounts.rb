class AddNamePhoneCountryToAccounts < ActiveRecord::Migration
  def self.up
  	add_column :accounts, :first_name,   :string, after: :type
  	add_column :accounts, :last_name,    :string, after: :first_name
  	add_column :accounts, :phone_number, :string, after: :last_name
  	add_column :accounts, :country,      :string, after: :phone_number
  end

  def self.down
  	remove_column :accounts, :first_name
  	remove_column :accounts, :last_name
  	remove_column :accounts, :phone_number
  	remove_column :accounts, :country
  end
end
