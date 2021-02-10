Rails.application.routes.draw do
  devise_for :users,
    controllers: { registrations: 'users/registrations',
                   omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'top#index'
  resources :users, only: [:index, :show] do
    collection do
      get 'search'
      get 'result'
    end
    member do
      get 'follower'
      get 'followed'
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :matching, only: :index
  resources :chat_rooms, only: [:create, :show]
end
