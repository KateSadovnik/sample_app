Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'login', to: 'sessions#new'
  root 'static_pages#home' 
  # get 'static_pages/home'
  get 'help', to: 'static_pages#help'
  get 'static_pages/email'
  get 'static_pages/about'
  get 'static_pages/contacts'
  get 'signup', to: 'users#new'
  #get 'users/show'
  #get 'users/new'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
