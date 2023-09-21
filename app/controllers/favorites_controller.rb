# app/controllers/favorites_controller.rb

class FavoritesController < ApplicationController
  # ログインしているユーザーのみアクセス可能とする
  before_action :authenticate_user!

  # お気に入り登録
  def create
    @video = Video.find(params[:video_id])
    @favorite = current_user.favorites.build(video: @video)

    if @favorite.save
      # 保存成功時の処理
      redirect_back(fallback_location: root_path, notice: '動画をお気に入りに追加しました。')
    else
      # 保存失敗時の処理
      redirect_back(fallback_location: root_path, alert: '動画のお気に入り登録に失敗しました。')
    end
  end

  # お気に入り解除
  def destroy
    @favorite = current_user.favorites.find_by(video_id: params[:video_id])
    if @favorite&.destroy
      # 削除成功時の処理
      redirect_back(fallback_location: root_path, notice: '動画のお気に入り登録を解除しました。')
    else
      # 削除失敗時の処理
      redirect_back(fallback_location: root_path, alert: '動画のお気に入り登録の解除に失敗しました。')
    end
  end

  # お気に入り動画一覧
  def index
    @favorites = current_user.favorites.includes(:video).order(created_at: :desc)
  end

  # save_memoアクションの定義 (新規追加)
  def save_memo
    video_id = params[:video_id]
    new_memo = params[:memo]
    
    favorite = Favorite.find_by(video_id: video_id, user_id: current_user.id)

    if favorite
      favorite.update(memo: new_memo)
      render json: { success: true }
    else
      render json: { success: false }, status: :not_found
    end
  end
end
