Rails.application.routes.draw do

  resources :users, only: [:create]
  resources :skills, only: [:index, :new, :create, :show]

  root 'skills#index'

end
