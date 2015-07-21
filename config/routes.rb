Rails.application.routes.draw do
  scope module: :frontend do
    get 'signin', to: 'sessions#new', as: :signin
    post 'signin', to: 'sessions#create'
    get 'signup', to: 'caddies#new', as: :signup
    post 'signup', to: 'caddies#create'
    get 'signout', to: 'sessions#destroy', as: :signout
  end
  namespace :wechat do
    root 'base#verify', via: [:get, :post]
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resource :users do
      member do
        get :information_form
        post :complete
      end
    end
    resources :verification_codes do
      collection do
        post :send_for_complete_information
      end
    end
    resources :tasks
    get 'force_signin', to: 'sessions#force_new', as: :force_signin
    post 'force_signin', to: 'sessions#force_create'
    post 'signin', to: 'sessions#create'
    post 'force_signup', to: 'users#force_create', as: :force_signup
    get 'signout', to: 'sessions#destroy', as: :signout
  end
end