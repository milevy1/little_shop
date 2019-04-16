class Profile::OrdersController < ApplicationController
  before_action :require_reguser

  def index
    @user = current_user
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.user == current_user
      @order.order_items.where(fulfilled: true).each do |oi|
        item = Item.find(oi.item_id)
        item.inventory += oi.quantity
        item.save
        oi.fulfilled = false
        oi.save
      end

      @order.status = :cancelled
      @order.save

      redirect_to profile_orders_path
    else
      render file: 'public/404', status: 404
    end
  end

  def create
    order = Order.create(user: current_user, status: :pending)
    cart.items.each do |item, quantity|
      best_qualified_discount = item.best_discount(quantity)
      if best_qualified_discount
        item_unit_discount = best_qualified_discount.discount.to_f / best_qualified_discount.threshold.to_f
        order_price = item.price - (item.price * item_unit_discount)
      else
        order_price = item.price
      end

      order.order_items.create(item: item, quantity: quantity, price: order_price)
    end
    session.delete(:cart)
    flash[:success] = "Your order has been created!"
    redirect_to profile_orders_path
  end
end
