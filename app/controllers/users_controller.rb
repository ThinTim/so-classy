class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.create!(user_params)
    redirect_to(@user)
  rescue ActiveRecord::RecordInvalid
    existing_user = User.find_by_email(user_params[:email])
    redirect_to(existing_user) unless existing_user.nil?
  end

  def show
    @user = User.find(params[:id])
    render nothing: true
  end

private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
