class Block < ActiveRecord::Base
	self.table_name = 'block'

  TIME_FORMAT = "%F %X"

  has_many :block_txs
  has_many :txin_details
  has_many :txout_details
  
  belongs_to :prev_block, foreign_key: "prev_block_id", class_name: "Block"

  def time_to_string
    Time.at(block_nTime).utc.strftime(TIME_FORMAT)
  end

end
