class TxoutDetail < ActiveRecord::Base
	self.table_name = 'txout_detail'

  POS_HEIGHT = 10_000
  default_scope where("( txout_pos <> 0 AND block_height >= ? ) OR block_height < ?", POS_HEIGHT, POS_HEIGHT)
	
	belongs_to :tx, foreign_key: :tx_id, primary_key: :tx_id

  belongs_to :pubkey, foreign_key: "pubkey_id"

  belongs_to :block
  belongs_to :tx
end
