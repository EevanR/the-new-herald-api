Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth', skip: [:omniauth_callbacks]
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :articles, only: [:show, :index]
      resources :subscriptions, only: [:create]
      namespace :admin, defaults: { format: :json } do
        resources :articles, only: [:create, :update, :index, :show, :destroy]
        resources :users, only: [:show]
        resources :comments, only: [:index, :create, :show]
      end
    end
  end
end