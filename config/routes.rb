Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  # resource :dashboard, only: :show
  resources :games, only: [:index, :show, :new, :create, :update]
  resources :moves, :pieces
end