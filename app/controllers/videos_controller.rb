class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show]

  def index
    sort_order = params[:sort] == 'newest' ? :desc : :asc
    @videos = Video.all.order(published_at: sort_order)
    @from_database = true
  end

  def search
    query = params[:search_query] || params[:keyword] || session[:last_search_query]

    session[:last_search_query] = query if query.present?

    if query.present?
      Rails.logger.debug "Search query: #{query}"
      @videos = Video.search(query)

      if @videos.empty?
        Rails.logger.debug "No videos found in the database. Searching YouTube API..."
        search_results = Video.search_from_youtube(query, 20)
        save_search_results(search_results)
        @videos = Video.where(url: search_results.map { |data| data[:url] })
        @from_database = false
      else
        @from_database = true
      end

      apply_time_filter_and_sort_order(params[:time_filter], params[:sort])
    else
      @videos = Video.none
    end

    render :index
  rescue YoutubeService::YoutubeAPIError => e
    flash[:error] = e.message
    @videos = Video.none
    render :index
  end

  def show
    @video_details = @video || fetch_video_details(params[:id])
    @reviews = @video.reviews.order(created_at: :desc) if @video&.reviews
    @recommended_videos = Video.recommended(@video)

    @folders = current_user.folders
    @review = Review.new(video: @video) # Reviewインスタンスを初期化
  end

  def favorites
    @favorites = current_user.favorites.includes(:video)
  end

  private

  def set_video
    @video = Video.find_by(id: params[:id])
    unless @video
      video_data = YoutubeService.fetch_video_details_by_id(params[:video_id] || params[:id])
      if video_data
        @video = Video.new(video_data)
        @video.save
      else
        flash[:alert] = "動画が見つかりませんでした。"
        redirect_to videos_path
      end
    end
  end

  def video_params
    params.require(:video).permit(:title, :url, :description)
  end

  def fetch_video_details(video_id)
    video_data = YoutubeService.fetch_video_details_by_id(video_id)
    return nil unless video_data
    Video.new(video_data)
  end

  def save_search_results(search_results)
    search_results.each do |video_data|
      video = Video.find_or_initialize_by(url: video_data[:url])
      video.assign_attributes(video_data)
      video.save if video.changed?
    end
  end

  def apply_time_filter_and_sort_order(time_filter, sort_order)
    @videos = filter_videos_by_time(@videos, time_filter)
    sort_order = sort_order == 'newest' ? :desc : :asc
    @videos = @videos.order(published_at: sort_order)
  end

  def filter_videos_by_time(videos, time_filter)
    case time_filter
    when 'today'
      videos.where('published_at > ?', 1.day.ago)
    when 'thisweek'
      videos.where('published_at > ?', 1.week.ago)
    when 'thismonth'
      videos.where('published_at > ?', 1.month.ago)
    when 'thisyear'
      videos.where('published_at > ?', 1.year.ago)
    else
      videos
    end
  end
end
