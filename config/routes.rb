Rails.application.routes.draw do

  root 'topics#index'

  resources :topics, only: [:index, :new, :create, :show] do
    post 'add_teacher', on: :member
  end

  post 'users/login', :to => 'users#login', :as => :login
  post 'users/logout', :to => 'users#logout', :as => :logout

end
