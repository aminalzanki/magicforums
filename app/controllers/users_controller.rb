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

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user.update(users_params)
      redirect_to root_path
    else
      redirect_to edit_user_path(@user)
    end
  end

  private

  def users_params
    params.require(:user).permit(:email, :password, :username, :image)
  end
end
