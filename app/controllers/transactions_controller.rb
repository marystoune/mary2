class TransactionsController < ApplicationController
  def show
    @tx = Tx.includes(:block_tx => :block).find(params[:id])
  end
end
