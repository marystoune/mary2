class CreateQiwicoinTransfers < ActiveRecord::Migration
  def change
    create_table :qiwicoin_transfers do |t|
      t.decimal :amount, precision: 16, scale: 8, default: 0.0
      t.string  :address
      t.string  :qc_tx_id
      t.string  :comment

      t.timestamps
    end

    add_index :qiwicoin_transfers, :address
  end
end
