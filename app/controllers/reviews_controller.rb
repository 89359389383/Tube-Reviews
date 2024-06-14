class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :set_video, only: [:create]

  SORT_MAPPINGS = {
    "動画タイトル" => "videos.title",
    "感想タイトル" => "title",
    "投稿日時" => "created_at"
  }

  def index
    @reviews = Review.order(created_at: :desc)

    # フォルダIDに基づくフィルタリング
    if params[:folder_id].present?
      @reviews = @reviews.where(folder_id: params[:folder_id])
    end

    # ページネーション
    @reviews = @reviews.page(params[:page]).per(30)
    @prev_page_token = @reviews.prev_page
    @next_page_token = @reviews.next_page

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @folders = current_user.folders
  end

  def new
    @review = Review.new
    @folders = current_user.folders # フォルダ選択用
  end

  def create
    @review = @video.reviews.new(review_params)
    @review.user = current_user
    @review.play_time = params[:review][:play_time] # play_timeを設定

    # 新しいフォルダ名が入力されている場合は、そのフォルダを作成または取得
    if params[:new_folder_name].present?
      folder = current_user.folders.find_or_create_by(name: params[:new_folder_name])
      @review.folder_id = folder.id
    end

    if @review.save
      # レビューが保存された後、動画の詳細ページにリダイレクト
      redirect_to video_path(@review.video), notice: '感想が保存されました。'
    else
      render 'videos/show'
    end
  end

  def edit
    @folders = current_user.folders # フォルダ選択用
  end

  def update
    if @review.update(review_params)
      redirect_to reviews_path, notice: '感想を更新しました'
    else
      @folders = current_user.folders # フォルダ選択用
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @review && @review.user == current_user
      @review.destroy
      respond_to do |format|
        format.html do
          if request.referer.include?(reviews_path)
            redirect_to reviews_path, notice: '感想が正常に削除されました。'
          else
            redirect_to video_path(@review.video), notice: '感想が正常に削除されました。'
          end
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to video_path(@review.video), alert: '感想の削除に失敗しました。' }
        format.json { head :forbidden }
      end
    end
  end

  private

  def fetch_reviews
    reviews = current_user.reviews.includes(:video)

    # 検索によるフィルタリング
    if params[:search].present?
      reviews = reviews.joins(:video).where("videos.title LIKE ?", "%#{params[:search]}%")
    end

    # ソート
    if params[:sort].present? && SORT_MAPPINGS.keys.include?(params[:sort])
      sort_column = SORT_MAPPINGS[params[:sort]]
      direction = (params[:direction] == "desc" ? "DESC" : "ASC")
      reviews = reviews.order("#{sort_column} #{direction}")
    else
      reviews = reviews.order("reviews.created_at DESC")
    end

    # フォルダによるフィルタリング
    if params[:folder_id].present?
      reviews = reviews.where(folder_id: params[:folder_id])
    end

    reviews # ページネーション関連のコードを削除
  end

  def review_params
    params.require(:review).permit(:title, :body, :video_id, :play_time, :folder_id, :new_folder_name)
  end

  def set_review
    @review = Review.find_by(id: params[:id])
    unless @review
      redirect_to reviews_path, alert: '指定された感想は存在しません。'
    end
  end

  def authorize_user!
    unless @review.user == current_user
      redirect_to reviews_path, alert: '他のユーザーの感想を編集・削除する権限がありません。'
    end
  end

  def set_video
    @video = Video.find(params[:video_id])
  end
end