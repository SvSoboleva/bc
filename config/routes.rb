Rails.application.routes.draw do
  devise_for :users
  root "books#index"

  resources :books
  resources :users, only: [:show, :edit, :update]
  resources :sections
  resources :lists

  resources :books do
    member do
      get 'create_booklist'
    end
  end
end
