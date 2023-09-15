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
  end

  def show
    # ここで特定のレビューを表示するためのコード
  end

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)

    if @review.save
      redirect_to reviews_path, notice: 'Review successfully created.'
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to reviews_path, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_path, notice: 'Review was successfully deleted.'
  end

  private

  def fetch_reviews
    reviews = current_user.reviews.includes(:video)

    # 検索
    reviews = reviews.joins(:video).where("videos.title LIKE ?", "%#{params[:search]}%") if params[:search].present?

    # ソート
    if params[:sort].present? && SORT_MAPPINGS.keys.include?(params[:sort])
      sort_column = SORT_MAPPINGS[params[:sort]]
      direction = (params[:direction] == "desc" ? "DESC" : "ASC")
      reviews = reviews.order("#{sort_column} #{direction}")
    end

    # ページネーションの適用
    reviews.page(params[:page]).per(10)
  end

  def review_params
    params.require(:review).permit(:title, :body, :video_id)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: 'Not authorized.' unless current_user == @review.user
  end
end

