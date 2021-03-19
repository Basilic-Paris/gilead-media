class Admin::UsersController < ApplicationController
  before_action :disable_turbolinks_cache, only: %i[index create destroy]

  def index
    @users = policy_scope([:admin, User])
    @user = User.new
  end

  def create
    @users = policy_scope([:admin, User])
    @user = User.new(user_params)
    authorize([:admin, @user])
    if @user.save
      @user.need_change_password! # thanks to gem devise-security
      redirect_to admin_users_path
    else
      render :index
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize([:admin, @user])
    @user.destroy
    redirect_to admin_users_path, { flash: { validation_message: true, message: "L'utilisateur a bien été supprimé." } }
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end
