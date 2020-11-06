class Admin::MerchantsController < Admin::DashboardController

  def show
    @user = current_user
    @orders = @user.orders.where(status: 'pending')
    binding.pry
  end

  def index
    @merchants = Merchant.all
  end
end
