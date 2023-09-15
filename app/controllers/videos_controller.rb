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
      Rails.logger.debug "Search query: #{query}"  # デバッグログ: 検索クエリを出力

      @videos = Video.search(query)
      if @videos.empty?
        Rails.logger.debug "No videos found in the database. Searching YouTube API..."  # デバッグログ: データベースにビデオが見つからなかった場合
        @videos = Video.search_from_youtube(query)
        if @videos.present?
          @videos.each do |video|
            _video=Video.where(url: video[:url]).last
            if _video.nil?
            p "========== video from youtube API"
            p video
              Video.create!(title: video[:title], description: video[:description], url: video[:url])
            end  
          end
        end
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
  
  def favorites
    @favorites = current_user.favorites.includes(:video)
  end

  private
  
  def set_video
    @video = Video.find_by(id: params[:id])
    
    unless @video
      video_data = youtube_video_details(params[:id])
      if video_data
        @video = Video.new(
          title: video_data[:title],
          description: video_data[:description],
          url: video_data[:url]
        )
        @video.save
      end
    end
  end

  def video_params
    params.require(:video).permit(:title, :url, :description)
  end

  def youtube_video_details(video_id)
    video_response = YOUTUBE_SERVICE.list_videos('snippet,contentDetails', id: video_id, max_results: 1)
    Rails.logger.debug video_response.to_json

    # Check if the response contains an error
    if video_response.error?
      Rails.logger.error "YouTube API Error: #{video_response.error_message}"  # デバッグログ: YouTube API エラーの場合
      return nil
    end

    video = video_response.items.first
    return nil unless video

    {
      title: video.snippet.title,
      description: video.snippet.description,
      url: "https://www.youtube.com/watch?v=#{video.id}"
    }
  end
  
  def fetch_video_details(video_id)
    video_data = youtube_video_details(video_id)
    return nil unless video_data

    Video.new(video_data)
  end
end

