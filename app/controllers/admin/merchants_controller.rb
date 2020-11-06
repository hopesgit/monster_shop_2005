class Admin::MerchantsController < Admin::DashboardController

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @orders = Order.where(status: "pending").joins(:items).where(items: {merchant_id: @merchant.id}).distinct
  end

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    merchant.update(active?: false)
    merchant.save
    flash[:success] = "Merchant disabled."
    redirect_to "/admin/merchants"
  end
end
