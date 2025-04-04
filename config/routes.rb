Rails.application.routes.draw do

  devise_for :users

  root 'static_pages#landing_page'
  get 'static_pages/index'
  get 'dashboard', to: 'home#dashboard'
  get 'pricing', to: 'static_pages#pricing'
  get 'about', to: 'static_pages#about'
  get 'privacy', to: 'static_pages#privacy'
  get 'terms', to: 'static_pages#terms'

  resources :users, only: [:index, :show] do
    member do
      patch :resend_invitation
    end
  end

  resources :tenants do
    get :my, on: :collection
    member do
      patch :switch
    end
  end


  resources :members, execpt: [:create, :new] do
    get :invite, on: :collection
  end
end
