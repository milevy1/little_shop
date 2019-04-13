class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = User.find_by(slug: params[:merchant_slug])
    @items = @merchant.items
    render :'/dashboard/items/index'
  end
end
