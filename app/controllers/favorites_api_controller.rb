class FavoritesApiController < ApplicationController
  def index
    @favorites = Favorite.all

    render json: @favorites.to_json(include: :video)
  end
end
