Rails.application.routes.draw do

  resources :users, only: [:new, :create, :show]
  resources :skills, only: [ :index, :new, :create, :show ]

  root 'welcome#index'

end
