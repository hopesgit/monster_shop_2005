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
    if merchant.active?
      disable(merchant)
    else
      enable(merchant)
    end
  end

  def disable(merchant)
    merchant.update(active?: false)
    merchant.save
    merchant.items.each do |item|
      item.update(active?: false)
      item.save
    end
    flash[:success] = "Merchant disabled."
    redirect_to "/admin/merchants"
  end

  def enable(merchant)
    merchant.update(active?: true)
    merchant.save
    merchant.items.each do |item|
      item.update(active?: true)
      item.save
    end
    flash[:success] = "Merchant re-enabled."
    redirect_to "/admin/merchants"
  end
end
