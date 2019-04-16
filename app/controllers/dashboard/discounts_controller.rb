class Dashboard::DiscountsController < Dashboard::BaseController
  def index
    @discounts = current_user.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = current_user.discounts.new(discount_params)

    if @discount.save
      redirect_to dashboard_discounts_path
    else
      flash.now[:danger] = @discount.errors.full_messages
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)

    if @discount.save
      flash[:success] = "Your discount has been updated"
      redirect_to dashboard_discounts_path
    else
      flash.now[:danger] = @discount.errors.full_messages
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])

    discount.destroy
    flash[:success] = "Discount Successfully Deleted!"

    redirect_to dashboard_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :discount, :threshold)
  end
end
