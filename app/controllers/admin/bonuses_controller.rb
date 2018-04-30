class Admin::BonusesController < Admin::AdminController

	active_scaffold :bonus do |config|
    config.actions = [:list, :show, :search]
    columns[:account_id].label = "User"

    config.action_links.add :index, label: 'All', parameters: { }, position: false
    config.action_links.add :index, label: 'Is Pending', parameters: { status: 'pending' }, position: false

    config.label = "Bonuses"

    config.list.columns = [
      :id,
      :account,
      :amount,
      :created_at,
      :email,
      :last_name,
      :status
    ]

    config.columns[:account].actions_for_association_links = [:show]

    config.show.columns = [
      :id,
      :email,
      :amount,
      :address,
      :qc_tx_id,
      :is_sended,
      :status,
      :created_at
    ]

    config.action_links.add 'approve_tx', 
      :label => 'Approve', 
      :type => :member, 
      :method => :post,
      :position => false
      
    config.action_links.add 'decline_tx', 
      :label => 'Decline', 
      :type => :member, 
      :method => :post,
      :position => false

    config.search.columns = [:address, :qc_tx_id, :status]
    list.sorting = {:id => 'DESC'}
  end

  def approve_tx
    @record = Bonus.find(params[:id])
    
    if @record.status == 'pending'
      @record.status = 'approved'
      @record.save!(validate: false)
      @record.update_child_bonuses("approved")
    end

    render :template => 'admin/bonuses/approve_tx'
  end

  def decline_tx
    @record = Bonus.find(params[:id])
    
    if @record.status == 'pending'
      @record.status = 'declined'
      @record.save!(validate: false)
      @record.update_child_bonuses("declined")
    end

    render :template => 'admin/bonuses/decline_tx'
  end

end
