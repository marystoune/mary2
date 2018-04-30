class InformationsController < ApplicationController

  DEFAULT_BLOCKS_AMOUNT_IN_TABLE = 7
  DEFAULT_TXS_AMOUNT_IN_TABLE = 10

  

  before_filter :check_current_user_before_post_contact_us, only: [:contact_us]

  #blockchain index
	def welcome
		@blocks = Block.order("block_height desc").first(DEFAULT_BLOCKS_AMOUNT_IN_TABLE)
		@txs = Tx.includes(:block_tx => :block).order("tx_id desc").first(DEFAULT_TXS_AMOUNT_IN_TABLE)
  end

  def start
  end
	
	# root
  def welcome_qiwicoin
    @txs = Tx.includes(:block_tx => :block).order("tx_id desc").first(DEFAULT_TXS_AMOUNT_IN_TABLE)
    @with_search = false
	end

  def terms_of_use
  end

  def contact_us
    if request.get?
      @email_to_admin = EmailToAdmin.new
      @email_to_admin.account = current_user if current_user
    else
      @email_to_admin = EmailToAdmin.new(email_to_admin_params)
      @email_to_admin.account = current_user if current_user
      @is_saved = @email_to_admin.save
    end

  end

  private

  def check_current_user_before_post_contact_us
    redirect_to :root if (request.post? && !current_user) || (request.post? && current_user && current_user.is_banned_for_send_email_to_admin?) 
  end

  def email_to_admin_params
    params.require(:email_to_admin).permit(:name, :subject, :message)
  end

end
