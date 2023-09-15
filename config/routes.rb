Rails.application.routes.draw do
  devise_for :users

  get 'videos/search', to: 'videos#search', as: 'search_videos'

  resources :videos do
    resources :reviews, except: [:index, :new, :destroy]
    
    # お気に入りの追加・削除をするためのルーティングを追加
    resource :favorite, only: [:create, :destroy]

    # お気に入り動画の一覧表示のためのルーティングを追加
    collection do
      get :favorites
    end
  end

  resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]

  # お気に入り動画の一覧表示のルーティングを追加
  get 'favorites', to: 'favorites#index', as: 'favorites'

  # authenticatedとunauthenticatedのルート設定をコメントアウトしています。
  # 必要に応じてコメントアウトを外し、適切なルートへ変更してください。
  # authenticated :user do
  #   root 'videos#index', as: :authenticated_root
  # end

  # unauthenticated :user do
  #   root to: "devise/sessions#new"
  # end

  # 現在のデフォルトのルート設定
  root 'videos#index'
end 

