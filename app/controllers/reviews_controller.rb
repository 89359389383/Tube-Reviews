class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  SORT_MAPPINGS = {
    "動画タイトル" => "videos.title",
    "感想タイトル" => "title",
    "投稿日時" => "created_at"
  }

  def index
    @reviews = fetch_reviews

    respond_to do |format|
      format.html # 通常のHTTPリクエストに対するレスポンス
      format.js   # Ajaxリクエストに対するレスポンス
    end
  end

  def show
  end

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    @video = Video.find(params[:video_id])
    @review.video = @video

    if @review.save
      redirect_to @video, notice: '感想を投稿しました'
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to reviews_path, notice: '感想を更新しました'
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @review && @review.user == current_user
      @review.destroy
      redirect_to reviews_path, notice: '感想が正常に削除されました'
    else
      redirect_to reviews_path, alert: '感想の削除に失敗しました'
    end
  end

  private

  def fetch_reviews
    reviews = current_user.reviews.includes(:video)

    if params[:search].present?
      reviews = reviews.joins(:video).where("videos.title LIKE ?", "%#{params[:search]}%")
    end

    if params[:sort].present? && SORT_MAPPINGS.keys.include?(params[:sort])
      sort_column = SORT_MAPPINGS[params[:sort]]
      direction = (params[:direction] == "desc" ? "DESC" : "ASC")
      reviews = reviews.order("#{sort_column} #{direction}")
    else
      reviews = reviews.order("reviews.created_at DESC")
    end

    reviews.page(params[:page]).per(10)
  end

  def review_params
    params.require(:review).permit(:title, :body, :video_id)
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
end
