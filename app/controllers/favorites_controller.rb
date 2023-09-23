# app/controllers/favorites_controller.rb

class FavoritesController < ApplicationController
  # ユーザーがログインしているか確認
  before_action :authenticate_user!

  # お気に入り動画を作成するアクション
  def create
    # Video ID に基づいて動画を検索
    @video = Video.find(params[:video_id])
    # 現在のユーザーに対して新しいお気に入りをビルド（初期化）
    @favorite = current_user.favorites.build(video: @video)
    
    # 保存を試みる
    if @favorite.save
      # 保存成功時
      redirect_back(fallback_location: root_path, notice: '動画をお気に入りに追加しました。')
    else
      # 保存失敗時
      redirect_back(fallback_location: root_path, alert: '動画のお気に入り登録に失敗しました。')
    end
  end

  # お気に入りを削除するアクション
  def destroy
    # 現在のユーザーとVideo IDに一致するお気に入りを探す
    @favorite = current_user.favorites.find_by(video_id: params[:video_id])
    
    # お気に入りが存在する場合、削除を試みる
    if @favorite&.destroy
      # 削除成功時
      redirect_back(fallback_location: root_path, notice: '動画のお気に入り登録を解除しました。')
    else
      # 削除失敗時
      redirect_back(fallback_location: root_path, alert: '動画のお気に入り登録の解除に失敗しました。')
    end
  end

  # お気に入りの一覧を表示するアクション
  def index
    # 現在のユーザーのお気に入りを作成日時の降順で取得
    @favorites = current_user.favorites.includes(:video).order(created_at: :desc)
  end

  # メモを保存するアクション
  def save_memo
    # パラメータからVideo IDと新しいメモを取得
    video_id = params[:video_id]
    new_memo = params[:memo]
    
    # メモの更新を試みる
    favorite = Favorite.find_by(video_id: video_id, user_id: current_user.id)
    
    if favorite
      # 更新成功時
      favorite.update(memo: new_memo)
      render json: { success: true }
    else
      # 更新失敗時
      render json: { success: false }, status: :not_found
    end
  end
end
