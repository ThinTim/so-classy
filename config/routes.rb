Rails.application.routes.draw do

  root 'topics#index'

  resources :topics, only: [:index, :new, :create, :show] do
    post 'add_teacher', on: :member
    post 'remove_teacher', on: :member
    post 'add_student', on: :member
    post 'remove_student', on: :member
  end

  post 'users/login', :to => 'users#login', :as => :login
  post 'users/logout', :to => 'users#logout', :as => :logout

  resources :users, only: [] do
    get 'authenticate', to: 'users#authenticate', :on => :member
  end

end
