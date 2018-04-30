class Admin::QiwicoinTransfersController < Admin::AdminController

	active_scaffold :qiwicoin_transfer do |config|
    config.label = "Qiwicoin Transfers"
    config.create.label = "Create Qiwicoin Transfer"
    config.actions = [:list, :show, :create, :search]

    config.list.columns = [
      :id,
      :amount,
      :created_at
    ]

    config.show.columns = [
      :id,
      :amount,
      :address,
      :qc_tx_id,
      :comment,
      :created_at
    ]

    config.create.columns = [
      :amount,
      :address,
      :comment
    ]

    config.search.columns = :address
    list.sorting = {:id => 'DESC'}
  end

  def create
    @record = QiwicoinTransfer.new do |ct|
      ct.amount  = params[:record][:amount].to_f
      ct.address = params[:record][:address]
      ct.comment = params[:record][:comment] if params[:record][:comment].present?
    end

    if @record.save
      @record.make_withdraw
    else
      self.successful = false
    end

    respond_to_action(:create)
  end

end
