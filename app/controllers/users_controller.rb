class UsersController < ApplicationController

  def create
    reset_session
    
    @user = User.create!(user_params)
    session[:user_id] = @user.id
    redirect_to(:root)
  rescue ActiveRecord::RecordInvalid
    existing_user = User.find_by_email(user_params[:email])
    session[:user_id] = existing_user.id
    redirect_to(:root)
  end

private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
