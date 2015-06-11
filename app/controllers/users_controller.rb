class UsersController < ApplicationController

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
