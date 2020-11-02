class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(name: order_params[:name],
                         address: order_params[:address],
                         city: order_params[:city],
                         state: order_params[:state],
                         zip: order_params[:zip],
                         user_id: current_user.id)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)

      order.item_orders.each do |item_order|
        item_order.check_out_items
      end

      flash[:message] = "Your order has been created"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.update(status: 3)
    order.save
    order.item_orders.each do |item_order|
      item_order.update(status: "unfulfilled")
      item_order.return_ordered_items
    end
    flash[:alert] = "The order is now cancelled."
    redirect_to "/profile"
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
