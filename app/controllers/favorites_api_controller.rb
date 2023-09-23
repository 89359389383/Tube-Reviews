module Api
  class FavoritesController < ApplicationController
    # 既存のindexアクション
    def index
      @favorites = Favorite.all
      render json: @favorites.to_json(include: :video)
    end

    # 追加するsearchアクション
    def search
      keyword = params[:keyword]
      @favorites = Favorite.joins(:video).where("videos.title LIKE ?", "%#{keyword}%")
      render json: @favorites.to_json(include: :video)
    end
  end
end
