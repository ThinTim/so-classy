class UsersController < ApplicationController
  skip_before_filter :authenticate_user, only: [ :login, :logout, :authenticate ]

  def login
    user = begin
      User.create!(email: params[:email])
    rescue ActiveRecord::RecordInvalid
      User.find_by_email(params[:email])
    end

    user.token = SecureRandom.hex
    user.save!

    UserMailer.sign_in(user).deliver_later

    flash[:success] = 'Check your email for a login link'
    redirect_to(:root)
  end

  def authenticate
    reset_session

    user = User.find(params[:id])
    if user.token == params[:token]
      session[:user_id] = user.id
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

  def update
    user_params = params.require(:user).permit(:name)
    user = User.find(params[:id])

    if(user == current_user)
      user.update!(user_params)
      flash[:success] = 'Update successful'
      redirect_to :root
    else
      render nothing: true, status: 403
    end
  end

end
