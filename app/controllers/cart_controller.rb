class CartController < ApplicationController
  before_action :visitor_or_user

  def show
  end

  def increment
    unless item = Item.find_by(slug: params[:id])
      item = Item.find(params[:id])
    end
    
    if item.inventory <= cart.count_of(item.id)
      flash[:danger] = "The Merchant does not have enough inventory."
    else
      cart.add_item(item.id)
      session[:cart] = cart.contents
      flash[:success] = "#{item.name} has been added to your cart!"
    end
    redirect_to cart_path
  end

  def decrement
    item = Item.find_by(slug: params[:id])
    cart.remove_item(item.id)
    session[:cart] = cart.contents
    flash[:success] = "#{item.name} has been removed from your cart."
    redirect_to cart_path
  end

  def destroy
    session.delete(:cart)
    redirect_to cart_path
  end

  def remove_item
    item = Item.find_by(slug: params[:id])
    session[:cart].delete(item.id.to_s)
    flash[:success] = "#{item.name} has been removed from your cart."
    redirect_to cart_path
  end
end
