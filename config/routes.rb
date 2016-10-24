Rails.application.routes.draw do
  resources :users do
    resources :posts, only: [:index]
    resources :comments, only: [:index]
  end

  resources :posts do
    resources :comments, only: [:index]
  end

  resources :comments, except: [:index]

  resource :session, only: [:create, :destroy]
end
