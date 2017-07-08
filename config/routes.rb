Rails.application.routes.draw do
  devise_for :users
  root "books#index"

  resources :books
  resources :users, only: [:show, :edit, :update]
  resources :sections
  resources :lists
  resources :booklists

  get 'books/:id', to: "books#create_booklist", as: :create_booklist
end
