class Admin::AccountsController < Admin::AdminController

  active_scaffold :account do |config|
    config.actions.exclude :create
    columns[:id].label = "ID"

    config.action_links.add :index, label: 'All', parameters: { }, position: false
    config.action_links.add :index, label: 'Is Verified', parameters: { is_verified: true }, position: false
    config.action_links.add :index, label: 'Is Not Verified', parameters: { is_verified: false }, position: false

    config.list.columns = [
      :id_label,
      :last_name,
      :email
    ]
#    config.columns[:id_label].sort = true
#    config.list.sorting.add :id, :asc

    config.update.columns = [
#      :id,
      :email,
      :first_name,
      :last_name,
      :phone_number,
      :country,
#      :confirmation_sent_at,
#      :confirmed_at,
#      :current_sign_in_at,
#      :current_sign_in_ip,
#      :failed_attempts,
#      :last_sign_in_at,
#     :last_sign_in_ip,
#      :locked_at,
      :is_verified
    ]
    

    config.columns[:country].form_ui = :select
    config.columns[:country].options = {:options => Country.all.sort.map { |c| [c[0], c[0]] } }
    config.show.columns = [
      :id,
      :email,
      :first_name,
      :last_name,
      :phone_number,
      :country,
      :confirmation_sent_at,
      :confirmed_at,
      :current_sign_in_at,
      :current_sign_in_ip,
      :failed_attempts,
      :last_sign_in_at,
      :last_sign_in_ip,
      :locked_at,
      :is_verified
    ]

    config.search.columns = [:id, :email, :phone_number,:first_name, :last_name, :country, :qwc_address_external, :current_sign_in_ip, :last_sign_in_ip]
    list.sorting = {:id => 'DESC'}
  end




















=begin
  def update
    @record = User.find(params[:id])

    if @record.is_verified && params[:record][:is_verified] == "0"
      msg = @record.message
      msg.destroy if msg
    end

    @record.is_verified = params[:record][:is_verified]

    unless @record.save
      self.successful = false
    end

    respond_to_action(:update)
  end
=end
end
