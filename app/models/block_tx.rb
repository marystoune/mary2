class BlockTx < ActiveRecord::Base
  self.table_name = "block_tx"
  belongs_to :block
  belongs_to :tx, foreign_key: "tx_id"
end