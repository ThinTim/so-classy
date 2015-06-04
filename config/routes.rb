Rails.application.routes.draw do

  post 'users/login', :to => 'users#login', :as => :login
  post 'users/logout', :to => 'users#logout', :as => :logout

  resources :skills, only: [:index, :new, :create, :show]

  root 'skills#index'

end
