Rails.application.routes.draw do
  devise_for :users

  # ビデオ検索のルート
  get 'videos/search', to: 'videos#search', as: 'search_videos'

  # ビデオとレビューのリソースルート
  resources :videos do
    resources :reviews, only: [:create, :destroy]
  end

  # 一時的にコメントアウト
  # authenticated :user do
  #   root 'videos#index', as: :authenticated_root
  # end

  # unauthenticated :user do
  #   root to: "devise/sessions#new"
  # end

  # デフォルトのルートを一時的に設定
  root 'videos#index'
end


