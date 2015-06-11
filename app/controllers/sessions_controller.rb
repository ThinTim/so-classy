class SessionsController < ApplicationController
  skip_before_filter :authenticate_user, only: [ :new ]

  def new
  end

end
