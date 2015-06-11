Rails.application.routes.draw do

  root 'sessions#new'

  resources :sessions, only: [ :create ] do
    post 'logout', to: 'sessions#destroy', on: :collection
    get 'logout', to: 'sessions#destroy', on: :collection
    get 'authenticate', to: 'sessions#authenticate', on: :member
  end

  resources :topics, only: [:index, :new, :create, :show] do
    post 'add_teacher', on: :member
    post 'remove_teacher', on: :member
    post 'add_student', on: :member
    post 'remove_student', on: :member
  end

  resources :users, only: [ :update ]

end
