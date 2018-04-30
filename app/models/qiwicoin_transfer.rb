class QiwicoinTransfer < ActiveRecord::Base

	validates :amount,
						presence: true,
						numericality: true,
						positive: true,
						minimal_amount: true,
						maximal_amount: true

	validates :address,
						presence: true,
						qiwicoin_address: true,
						not_mine_address: true


	# Sets a description of a record in the admin tools.
	def to_label
		"#{I18n.t("activerecord.models.qiwicoin_transfer.one")} n° #{id}"
	end

	# Sends qiwicoins from the server to any qiwicoin address.
	def make_withdraw
		if Qiwicoin::Client.instance.get_balance >= self.amount && self.address.present?
			self.qc_tx_id = Qiwicoin::Client.instance.send_to_address(self.address, self.amount.to_f)
			self.save
		end
  end

end
