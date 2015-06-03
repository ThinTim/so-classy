class WelcomeController < ApplicationController

  def index
    cookies['user_id'] ? identify_existing_user : create_new_user
  end

private

  def identify_existing_user
    user_id = cookies['user_id']
    user = User.find(user_id)
    redirect_to(user)
  end

  def create_new_user
    redirect_to(controller: :users, action: :new)
  end

end
