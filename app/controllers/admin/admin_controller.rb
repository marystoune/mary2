class Admin::AdminController < ApplicationController
	before_filter :authenticate_user!
	before_filter :require_admin_rights
  
        before_filter :set_flash_balance
        after_filter :reset_flash_balance

  def set_flash_balance
    flash[:bonus_balance] = nil
    flash[:bonus_balance] = "Balance: #{Qiwicoin::Client.instance.getbalance} QWC" if params[:controller] == "admin/bonuses"
  end

  def reset_flash_balance
    flash[:bonus_balance] = nil if params[:controller] == "admin/bonuses"
  end

  private
  def require_admin_rights
    unless current_user && current_user.is_admin?
      redirect_to root_path,
        alert: t('errors.insufficient_privileges')
    end
  end

end
