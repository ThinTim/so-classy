Rails.application.routes.draw do

  root 'sessions#new'

  resources :sessions, only: [ :create ] do
    get 'destroy', to: 'sessions#destroy', on: :collection, as: :destroy
    get 'authenticate', to: 'sessions#authenticate', on: :member
  end

  resources :topics, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    post 'add_teacher', on: :member
    post 'remove_teacher', on: :member
    post 'add_student', on: :member
    post 'remove_student', on: :member
  end

  resources :users, only: [ :show, :update, :edit ]

end
