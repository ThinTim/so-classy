Rails.application.routes.draw do

  root 'topics#index'

  resources :topics, only: [:index, :new, :create, :show] do
    post 'add_teacher', on: :member
    post 'remove_teacher', on: :member
    post 'add_student', on: :member
    post 'remove_student', on: :member
  end

  resources :users, only: [ :update ] do
    post 'login', to: 'users#login', on: :collection
    post 'logout', to: 'users#logout', on: :collection
    get 'logout', to: 'users#logout', on: :collection
    get 'authenticate', to: 'users#authenticate', on: :member
  end

end
