Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #Welcome
  root to: "welcome#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  # get "/merchants/:merchant_id/items", to: "items#index"
  # get "/merchants/:merchant_id/items/new", to: "items#new"
  # post "/merchants/:merchant_id/items", to: "items#create"

  resources :items, except: [:create, :new] do
    resources :reviews, only: [:new, :create]
  end
  # get "/items", to: "items#index"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  # get "/items/:id", to: "items#show"
  # delete "/items/:id", to: "items#destroy"


  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  #cart
  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  get '/cart/increment/:item_id', to: 'cart#increment_quantity'
  patch '/cart/increment/:item_id', to: 'cart#increment_quantity'
  get '/cart/decrement/:item_id', to: 'cart#decrement_quantity'
  patch '/cart/decrement/:item_id', to: 'cart#decrement_quantity'

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  
  # Users
  get "/register", to: "users#new"
  post '/register', to: 'users#create'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile/password/edit', to: 'users#password_edit'
  patch '/profile/password_update', to: 'users#password_update'
  get "/login", to: 'sessions#new'
  post "/login", to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/profile/orders', to: 'users#orders_index'
  put "/profile/orders/:id", to: "orders#update"
  get "/profile/orders/:id", to: "orders#show"

  # Merchants Only
  namespace :merchant do
    get "/", to: 'dashboard#show'
    resources :orders, only: [:show]
    resources :items, only: [:index]
  end

  # Admins Only
  namespace :admin do
    get "/", to: 'dashboard#show'
    resources :users, only: [:index, :show]
    resources :orders, only: [:update]
    get '/merchants', to: 'merchants#index'
    patch '/merchants/:merchant_id', to: 'merchants#update'
    get '/merchants/:merchant_id', to: 'merchants#show'
    # resources :merchant, only: [:show, :index, :update]
  end
end
