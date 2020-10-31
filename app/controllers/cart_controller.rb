class CartController < ApplicationController
  before_action :require_non_admin
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_quantity
    if cart.contents[params[:item_id]] < Item.find(params[:item_id]).inventory
      cart.contents[params[:item_id]] += 1
      redirect_to '/cart'
    else
      flash[:error] = "Not enough in stock"
      redirect_to '/cart'
    end 
  end

  private
  def require_non_admin
    render file: "/public/404" if current_admin?
  end
end
