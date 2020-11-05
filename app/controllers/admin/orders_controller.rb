class Admin::OrdersController < ApplicationController
  def update
    order = Order.find(params[:id])
    order.update(status: 2)
    order.save
    flash[:success] = "Order shipped."
    redirect_to admin_path
  end
end
