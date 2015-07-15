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
    resources :users do
      member do
        get :information_form
        post :complete
      end
    end
    get 'signin', to: 'sessions#new', as: :signin
    post 'signin', to: 'sessions#create'
    get 'signup', to: 'caddies#new', as: :signup
    post 'signup', to: 'caddies#create'
    get 'signout', to: 'sessions#destroy', as: :signout
  end
end