class Admin::UsersController < Admin::BaseController
  def index
    @users = User.default_users
  end

  def show
    @user = User.find_by(slug: params[:slug])
    if @user.role == "merchant"
      redirect_to admin_merchant_path(@user)
    end
  end

  def upgrade
    user = User.find_by(slug: params[:id])
    user.update(role: :merchant)
    flash[:success] = "#{user.name} is now a merchant."
    redirect_to admin_merchant_path(user)
  end
end
