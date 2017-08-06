Rails.application.routes.draw do

  namespace :users do
    get 'omniauth_callbacks/vkontakte'
  end

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  root "books#index"

  resources :books
  resources :users, only: [:show, :edit, :update]
  resources :sections
  resources :lists
  resources :chats

  resources :books do
    member do
      get 'create_booklist'
      get 'create_search'
    end
  end

  concern :commentable do |options|
    resources :comments, options
  end

  resources :books, only: [:create, :destroy] do
    concerns :commentable, commentable_type: 'Book'
  end

  resources :chats, only: [:create, :destroy] do
    concerns :commentable, commentable_type: 'Chat'
  end

end
