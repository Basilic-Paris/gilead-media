class Admin::UsersController < ApplicationController

  def index
    @users = policy_scope([:admin, User])
    @user = User.new()
  end

  def create
    @users = policy_scope([:admin, User])
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render :index
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end
