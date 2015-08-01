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
    resource :users
    resources :verification_codes do
      collection do
        post :send_for_sign_up
      end
    end
    resources :tasks do
      member do
        put :accept
        get :accept_successful
      end
    end
    get 'force_signin', to: 'sessions#force_new', as: :force_signin
    post 'force_signin', to: 'sessions#force_create'
    post 'force_signup', to: 'users#force_create', as: :force_signup
    post 'signin', to: 'sessions#create'
    get 'sign_up', to: 'users#sign_up_form', as: :sign_up_form
    post 'sign_up', to: 'users#sign_up', as: :sign_up
  end
end