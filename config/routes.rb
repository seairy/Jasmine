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
      collection do
        get :published
        get :demanded
        get :supplied
      end
      member do
        put :pay_deposit
        get :acceptable
        get :accept_confirmation
        put :accept
        get :accept_successful
        get :trashable
        get :trash_confirmation
        put :trash
        get :trash_successful
        get :cancelable
        get :cancel_confirmation
        put :cancel
        get :cancel_successful
        get :purchasable
        get :purchase_confirmation
        put :purchase
        get :purchase_successful
        get :clearable
        get :clear_confirmation
        put :clear
        get :clear_successful
      end
    end
    resources :consignees
    resource :instruction do
      collection do
        get :publish_task
        get :accept_task
      end
    end
    resource :account
    get 'error', to: 'base#error', as: :error
    get 'force_signin', to: 'sessions#force_new', as: :force_signin
    post 'force_signin', to: 'sessions#force_create'
    post 'force_signup', to: 'users#force_create', as: :force_signup
    post 'signin', to: 'sessions#create'
    get 'sign_up', to: 'users#sign_up_form', as: :sign_up_form
    post 'sign_up', to: 'users#sign_up', as: :sign_up
  end
end