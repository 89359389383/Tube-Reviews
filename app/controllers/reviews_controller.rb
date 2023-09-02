class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_video, only: [:new, :create, :edit, :update, :show]
  before_action :set_review, only: [:edit, :update, :show]
  before_action :authorize_user!, only: [:edit, :update]

  def new
    @review = Review.new
  end

  def create
    @review = @video.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to video_path(@review.video_id), notice: 'Review successfully created.'
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to video_path(@review.video_id), notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :video_id)
  end

  def set_video
    @video = Video.find(params[:video_id])
  end

  def set_review
    @review = @video.reviews.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: 'Not authorized.' unless current_user == @review.user
  end
end


