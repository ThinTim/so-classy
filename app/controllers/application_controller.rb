class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_filter :authenticate_user

  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id]) if @current_user.nil?
    end
    @current_user
  end

  def current_user?(user)
    return !user.nil? && current_user == user
  end

  protected

  def json_request?
    request.format.json?
  end

  def authenticate_user
    if current_user.nil?
      flash[:danger] = 'Please log in'
      redirect_to(:root)
    end
  end

end
