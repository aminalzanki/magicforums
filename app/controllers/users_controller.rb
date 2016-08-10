class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)

    if @user.save
      redirect_to root_path
    else
      redirect_to new_user_path
    end
  end

  def update
  end

  private

  def users_params
    params.require(:user).permit(:email, :password, :username, :image)
  end
end
