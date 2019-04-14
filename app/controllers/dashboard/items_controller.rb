class Dashboard::ItemsController < Dashboard::BaseController
  def index
    @items = current_user.items
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.new(item_params)
    @item.active = true
    if @item.save
      flash[:success] = "Your Item has been saved!"
      redirect_to dashboard_items_path
    else
      flash[:danger] = @item.errors.full_messages
      render :new
    end
  end

  def edit
    @item = Item.find_by(slug: params[:slug])
  end

  def update
    @item = Item.find_by(slug: params[:slug])
    if @item.update(item_params)
      flash[:success] = "Your Item has been updated!"
      redirect_to dashboard_items_path
    else
      flash[:danger] = @item.errors.full_messages
      @item = Item.find_by(slug: params[:slug])
      render :edit
    end
  end

  def enable
    @item = Item.find_by(slug: params[:id])

    if @item.user == current_user
      toggle_active(@item, true)
      redirect_to dashboard_items_path
    else
      render file: 'public/404', status: 404
    end
  end

  def disable
    @item = Item.find_by(slug: params[:id])
    if @item.user == current_user
      toggle_active(@item, false)
      redirect_to dashboard_items_path
    else
      render file: 'public/404', status: 404
    end
  end

  def destroy
    @item = Item.find_by(slug: params[:slug])
    if @item && @item.user == current_user
      if @item && @item.ordered?
        flash[:error] = "Attempt to delete #{@item.name} was thwarted!"
      else
        @item.destroy
      end
      redirect_to dashboard_items_path
    else
      render file: 'public/404', status: 404
    end
  end

  private

  def item_params
    item_parameters = params.require(:item).permit(:name, :price, :description, :image, :inventory)
    if item_parameters[:image].empty?
      item_parameters[:image] = "https://picsum.photos/200/300"
    end
    item_parameters
  end

  def toggle_active(item, state)
    item.active = state
    item.save
  end
end
