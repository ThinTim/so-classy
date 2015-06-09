class UsersController < ApplicationController
  skip_before_filter :authenticate_user, only: [ :login, :logout, :authenticate ]

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
    reset_session
    
    user = User.find(params[:id])
    if user.token == params[:token]
      session[:user_id] = user.id

      #Reset user's token so link doesn't work again
      user.token = SecureRandom.hex
      user.save!

      flash[:success] = 'Logged in successfully'
      redirect_to :root
    else
      flash[:error] = 'The link you followed was invalid or has expired. Please enter your email again to request a new link.'
      redirect_to :root
    end
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
