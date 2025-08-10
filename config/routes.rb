Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'static_pages#landing_page'
  # get 'static_pages/index'
  get 'pricing', to: 'static_pages#pricing'
  get 'about', to: 'static_pages#about'
  get 'privacy', to: 'static_pages#privacy'
  get 'terms', to: 'static_pages#terms'

  get 'dashboard', to: 'home#dashboard'

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

  resources :contacts

  get 'tenants/:tenant_id/leads/new', to: 'leads#new', as: :new_lead
  get 'tenants/:tenant_id/leads/:id', to: 'leads#show', as: :tenant_lead
  match 'tenants/:tenant_id/leads', to: 'leads#create', via:[ :post ], as: :create_lead
end
