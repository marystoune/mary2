class CreateBonusSettings < ActiveRecord::Migration
  def change
    create_table :bonus_settings do |t|
    	t.integer :begin
    	t.integer :end
    	t.decimal :amount, precision: 16, scale: 8, default: 0.0

      t.timestamps
    end
  end
end
