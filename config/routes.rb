Rails.application.routes.draw do

  get 'books/index'
  get 'books/show'
  get 'books/edit'
  devise_for :users
  root to: 'homes#top'
  get 'homes/about'
  resources :users, only: [:index,:show,:edit,:update]

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only:[:create,:destroy]
    resources :book_comments, only[:create,:destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
