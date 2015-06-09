class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user

  helper_method :current_user

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  protected

  def authenticate_user
    if not session[:user_id]
      flash[:info] = 'Please log in'
      redirect_to(:root)
    end
  end
end
