class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def show
    if current_user.admin?
      @merchant = Merchant.find(params[:merchant_id])
    else
      @user = current_user
      @merchant = @user.merchant
      @orders = @user.orders.where(status: 'pending')
    end
  end

  private
  def require_merchant
    render file: "/public/404" unless current_merchant? || current_admin?
  end
end
