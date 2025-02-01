Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root 'home#index'

  resources :users, only: [:index, :show]
end
