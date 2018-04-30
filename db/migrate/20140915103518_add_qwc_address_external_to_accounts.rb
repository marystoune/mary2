class AddQwcAddressExternalToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :qwc_address_external, :string, after: :country
  end
end
