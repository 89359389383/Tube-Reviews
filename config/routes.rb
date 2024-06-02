Rails.application.routes.draw do
  
  get 'videos/search', to: 'videos#search', as: 'search_videos'
  
  devise_for :users
  
  resources :videos do
    resources :reviews, except: [:index, :new, :destroy]
    resource :favorite, only: [:create, :destroy]
    collection do
      get :favorites
    end
  end

  resources :favorite_videos do
    member do
      delete 'delete'
    end
  end

  resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]

  get 'favorites', to: 'favorites#index', as: 'favorites'

  namespace :api do
    resources :favorites, only: [:index] do
      collection do
        get 'search'
      end
    end
    post 'save_memo', to: 'favorites#save_memo'
  end

  post 'guest_login', to: 'application#new_guest'

  resources :folders, only: [:destroy] do
    resources :reviews, only: [:index]

    member do
      get 'filter_reviews'
    end
  end

  resources :comments
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # authenticated :user do
  #   root 'videos#index', as: :authenticated_root
  # end

  # unauthenticated :user do
  #   root to: "devise/sessions#new"
  # end

  # 現在のデフォルトのルート設定 
  root 'videos#index'
end


