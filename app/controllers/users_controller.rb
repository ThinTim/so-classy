class UsersController < ApplicationController

  def create
    @user = User.create!(user_params)
    cookies[:user_id] = { value: @user.id, expires: 1.year.from_now }
    redirect_to(:root)
  rescue ActiveRecord::RecordInvalid
    existing_user = User.find_by_email(user_params[:email])
    cookies[:user_id] = { value: existing_user.id, expires: 1.year.from_now }
    redirect_to(:root)
  end

private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
