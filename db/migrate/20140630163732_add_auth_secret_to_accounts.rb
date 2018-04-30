class AddAuthSecretToAccounts < ActiveRecord::Migration
  def self.up
    add_column :users, :auth_secret, :string, after: 'encrypted_password'
  end

  def self.down
    remove_column :users, :auth_secret
  end
end
