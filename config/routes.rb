Rails.application.routes.draw do
  devise_for :users,
    controllers: { registrations: 'registrations' }
  root 'top#index'
  resources :users, only: [:index, :show]
  resources :relationships, only: [:create, :destroy]
  resources :matching, only: :index
  resources :chat_rooms, only: [:create, :show]
end
