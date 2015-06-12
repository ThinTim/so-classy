class UsersController < ApplicationController

  before_filter :correct_user, only: [ :edit, :update ]
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])

    user_params = params.require(:user).permit(:name)
    user.update!(user_params)

    flash[:success] = 'Update successful'
    redirect_to :root
  end

  private
    def correct_user
      @user = User.find(params[:id])
      if not current_user?(@user)
        flash[:error] = 'Can not update other users'
        redirect_to :root
      end
    end

end
