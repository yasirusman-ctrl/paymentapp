Rails.application.routes.draw do
  # Devise authentication routes for users
  devise_for :users

  # Root/home page
  root "home#index"
  post '/stripe/webhooks', to: 'stripe_webhooks#receive'

  # Admin Namespace
  namespace :admin do
    resources :users, only: [:index, :new, :create]
    resources :plans
    resources :features
    resources :usage_entries, only: [:index, :new, :create]
  end

  # Buyer Namespace
  namespace :buyer do
    resources :payment_methods, only: [:new, :create]
    resources :subscriptions, only: [:index, :new, :create, :show]
    resources :invoices, only: [:index, :show]
  end
end