Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'

  root to: 'pages#front'
  get '/register', to: 'users#new'

  resources :videos, only: [:index, :show] do
  	collection do
  		post 'search'
  	end
    resources :reviews, only: [:create]
  end
  
  get 'my_queue', to: 'queue_items#index'

  resources :categories, only: [:show]

  resources :users, only: [:create]

  resources :sessions, only: [:create]

  resources :queue_items, only: [:create]

end
