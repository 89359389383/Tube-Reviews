# app/controllers/videos_controller.rb
class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show]

  def index
    @videos = Video.all
    @from_database = true
  end

  def search
    query = params[:search_query] || params[:keyword]
    
    if query.present?
      @videos = Video.search(query)
      if @videos.empty?
        youtube_search(query)
        @from_database = false
      else
        @from_database = true
      end
    else
      @videos = []
    end

    @videos ||= []

    render 'index'
  end

  def show
    video_id = params[:id]
    @video_details = @video || fetch_video_details(video_id)
    @reviews = @video.reviews.order(created_at: :desc) if @video&.reviews
  end

  private
  
  def set_video
    @video = Video.find_by(id: params[:id])
    
    unless @video
      video_data = youtube_video_details(params[:id])
      if video_data
        @video = Video.new(
          title: video_data["snippet"]["title"],
          description: video_data["snippet"]["description"],
          url: "https://www.youtube.com/watch?v=#{video_data['id']}"
        )
        @video.save
      end
    end
  end

  def video_params
    params.require(:video).permit(:title, :url, :description)
  end

  def youtube_search(query)
    begin
      response = HTTParty.get("https://www.googleapis.com/youtube/v3/search?part=snippet&q=#{query}&key=#{ENV['YOUTUBE_API_KEY']}")
      @videos = response["items"] || []
    rescue HTTParty::Error => e
      logger.error("HTTParty error: #{e.message}")
      @videos = []
    rescue StandardError => e
      logger.error("General error: #{e.message}")
      @videos = []
    end
  end

  def youtube_video_details(video_id)
    begin
      response = HTTParty.get("https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&part=snippet,contentDetails&key=#{ENV['YOUTUBE_API_KEY']}")
      return response["items"].first
    rescue HTTParty::Error => e
      logger.error("HTTParty error: #{e.message}")
      return nil
    rescue StandardError => e
      logger.error("General error: #{e.message}")
      return nil
    end
  end
  
  def fetch_video_details(video_id)
    video_data = youtube_video_details(video_id)
    return nil unless video_data

    Video.new(
      title: video_data["snippet"]["title"],
      description: video_data["snippet"]["description"],
      url: "https://www.youtube.com/watch?v=#{video_data['id']}"
    )
  end
end

