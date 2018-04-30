class RenameColumnTypeForAccounts < ActiveRecord::Migration
  def change
  	rename_column :accounts, :type, :role
  end
end
