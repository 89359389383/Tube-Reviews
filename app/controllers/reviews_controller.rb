class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_video, only: [:new, :create]

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

  private

  def review_params
    params.require(:review).permit(:content, :video_id)
  end
  
  def set_video
    @video = Video.find(params[:video_id]) if params[:video_id].present?
  end
end
