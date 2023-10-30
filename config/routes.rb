# config/routes.rb

Rails.application.routes.draw do
  devise_for :users

  get 'videos/search', to: 'videos#search', as: 'search_videos'

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
        get 'search' # この行を追加
      end
    end
    post 'save_memo', to: 'favorites#save_memo' # 追加
  end
  
  # authenticated :user do
  #   root 'videos#index', as: :authenticated_root
  # end

  # unauthenticated :user do
  #   root to: "devise/sessions#new"
  # end

  # 現在のデフォルトのルート設定 
  # 現在のデフォルトのルート設定
  root 'videos#index'
end 
