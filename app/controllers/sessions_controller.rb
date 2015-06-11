class SessionsController < ApplicationController
  skip_before_filter :authenticate_user, only: [ :new, :create, :authenticate  ]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user = User.create!(email: params[:email]) if user.nil?
    user.token = SecureRandom.hex
    user.save!

    UserMailer.sign_in(user).deliver_later
    flash[:success] = "Check your email - we sent a sign in link to #{params[:email]}"
    redirect_to(:root)
  rescue ActiveRecord::RecordInvalid => exception
    flash[:error] = exception.message
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

  def destroy
    reset_session
    redirect_to(:root)
  end

end
