class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show]

  def index
    sort_order = params[:sort] == 'newest' ? :desc : :asc
    @videos = Video.all.order(published_at: sort_order).page(params[:page]).per(50)
    @from_database = true
  end

  def search
    query = params[:search_query] || params[:keyword] || session[:last_search_query]
    max_results = params[:max_results] || 50

    # 検索キーワードをセッションに保存
    session[:last_search_query] = query if query.present?

    if query.present?
      Rails.logger.debug "Search query: #{query}"
      @videos = Video.search(query)

      if @videos.empty?
        Rails.logger.debug "No videos found in the database. Searching YouTube API..."
        search_results = Video.search_from_youtube(query, max_results)

        search_results.each do |video_data|
          video = Video.find_or_initialize_by(url: video_data[:url])
          video.assign_attributes(
            title: video_data[:title],
            description: video_data[:description],
            thumbnail_url: video_data[:thumbnail_url],
            published_at: video_data[:published_at],
            duration: video_data[:duration],
            view_count: video_data[:view_count],
            channel_title: video_data[:channel_title]
          )
          video.save if video.changed?
        end

        @videos = Video.where(url: search_results.map { |data| data[:url] })
        @from_database = false
      else
        @from_database = true
      end

      # タイムフィルターとソート順の処理
      if params[:time_filter].present?
        @videos = filter_videos_by_time(@videos, params[:time_filter])
      end

      sort_order = params[:sort] == 'newest' ? :desc : :asc
      @videos = @videos.order(published_at: sort_order)

      # ページネーションの設定
      @videos = @videos.page(params[:page]).per(50)  # 1ページあたり20件を表示

    else
      @videos = Video.none.page(params[:page]).per(50)
    end

    render :index
  rescue YoutubeService::YoutubeAPIError => e
    flash[:error] = e.message
    @videos = Video.none.page(params[:page]).per(20)
    render :index
  end

  def show
    @video_details = @video || fetch_video_details(params[:id])
    @reviews = @video.reviews.order(created_at: :desc) if @video&.reviews
    @recommended_videos = Video.recommended(@video)

    # ユーザーのフォルダ一覧を取得
    @folders = current_user.folders
    @review = Review.new(video: @video) # ここでReviewインスタンスを初期化
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

  # タイムフィルターに基づくビデオのフィルタリング
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