class AddressesController < ApplicationController
	def show
		@address = Pubkey.includes(:txin_details, :txout_details).find(params[:id])

		@transactions = @address.txin_details + @address.txout_details
		@transactions.sort! { |tx1, tx2| tx1.block.block_nTime <=> tx2.block.block_nTime }
               @transactions = @transactions.paginate(:page => params[:page], :per_page => 50)
		@total_sent = @address.txin_details.sum(:txin_value)
		@total_received = @address.txout_details.sum(:txout_value)
		@balance = @total_received - @total_sent
	end
end
