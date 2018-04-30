class AddStatusToBonus < ActiveRecord::Migration
  def change
    add_column :bonus, :status, :string, after: :is_sended
  end
end
