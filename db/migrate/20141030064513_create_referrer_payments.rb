class CreateReferrerPayments < ActiveRecord::Migration
  def change
    create_table :referrer_payments do |t|
    	t.integer :account_id
    	t.decimal :amount, precision: 16, scale: 8, default: 0.0
      t.string  :address
      t.string  :qc_tx_id
      t.boolean :is_sended, default: false
      
      t.timestamps
    end
  end
end
