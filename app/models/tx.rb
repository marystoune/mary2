require 'digest/sha2'
require 'digest/rmd160'

class Tx < ActiveRecord::Base
	self.table_name = 'tx'

	has_many :txin_details, foreign_key: :tx_id, primary_key: :tx_id
	has_many :txout_details, foreign_key: :tx_id, primary_key: :tx_id

#  default_scope where(" ( SELECT COUNT( * ) FROM txout_detail WHERE txout_detail.tx_id = `tx`.tx_id ) > 0 ")        # =  (SELECT COUNT(*) FROM comments WHERE post_id = `posts`.id) < ?", n)

  has_one :block_tx
  delegate :block, to: :block_tx


end
