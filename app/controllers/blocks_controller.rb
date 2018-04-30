class BlocksController < ApplicationController
  def show
    @block = Block.includes(:prev_block, :txout_details, :txin_details).find_by_block_height(params[:block_height])
    @txs = @block.txin_details.group(:tx_hash) - @block.txout_details.group(:tx_hash)
  end
end
