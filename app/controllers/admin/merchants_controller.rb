class Admin::MerchantsController < Admin::DashboardController

  def show
    # @user = current_user
    # @orders = @user.orders.where(status: 'pending')
    @merchant = Merchant.find(params[:merchant_id])
    @orders = Order.where(status: "pending").joins(:items).where(items: {merchant_id: @merchant.id}).distinct
    # binding.pry
  end

  def index
    @merchants = Merchant.all
  end
end
