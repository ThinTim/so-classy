class UsersController < ApplicationController
  skip_before_filter :authenticate_user, only: [ :login, :logout ]

  def login
    reset_session
    
    @user = begin 
      User.create!(user_params) 
    rescue ActiveRecord::RecordInvalid
      User.find_by_email(user_params[:email])
    end

    @user.token = SecureRandom.hex
    @user.save!

    UserMailer.sign_in(@user).deliver_later

    flash[:success] = "Check your email for a login link"

    redirect_to(:root)
  end

  def authenticate
  end

  def logout
    reset_session
    redirect_to(:root)
  end

private

  def user_params
    params.require(:user).permit(:name, :email)
  end
  
end
