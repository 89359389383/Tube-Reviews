class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show]

  def index
    sort_order = params[:sort] == 'newest' ? :desc : :asc
    @videos = Video.all.order(published_at: sort_order).page(params[:page]).per(20)
    @from_database = true

    respond_to do |format|
      format.html # 通常のHTML応答
    end
  end

  def search
    query = params[:search_query] || session[:last_search_query]
    session[:last_search_query] = query if query.present?
    page_token = params[:page_token]

    if query.present?
      # YouTube APIを呼び出して動画を取得
      response = YoutubeService.search_videos(query, 20, page_token)
      @videos = response[:items]
      @next_page_token = response[:nextPageToken]
      @prev_page_token = response[:prevPageToken]
      @from_database = false
    else
      @videos = Video.none.page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html { render :index }
    end
  rescue YoutubeService::YoutubeAPIError => e
    flash[:error] = e.message
    @videos = Video.none
    render :index
  end

  def show
    @video = Video.find_by(id: params[:id])
    unless @video
      video_data = YoutubeService.fetch_video_details_by_id(params[:id])
      if video_data
        video_data.delete(:category_name)
        video_data[:url] ||= "https://www.youtube.com/watch?v=#{params[:id]}"
      
        # 重複チェック
        @video = Video.find_by(url: video_data[:url]) || Video.new(video_data)
        unless @video.save
          flash[:alert] = "動画の保存に失敗しました。"
          redirect_to videos_path and return
        end
      else
        flash[:alert] = "動画が見つかりませんでした。"
        redirect_to videos_path and return
      end
    end

    @video_details = @video
    @start_time = params[:start_time] || 0 # 再生開始時間のパラメータを取得

    # おすすめ動画を取得（キャッシュを無効化）
    @recommended_videos = fetch_recommended_videos(@video)

    # デバッグ情報を追加
    Rails.logger.debug "Recommended videos count: #{@recommended_videos.size}"
    Rails.logger.debug "Recommended videos: #{@recommended_videos.map(&:id).join(', ')}"
    @recommended_videos.each do |rv|
      Rails.logger.debug "Recommended video details: #{rv.attributes}"
    end

    @reviews = @video.reviews.order(created_at: :desc).page(params[:page]).per(10)
    @folders = current_user.folders
    @review = Review.new(video: @video)
  end

  def favorites
    @favorites = current_user.favorites.includes(:video)
  end

  private

  def set_video
    @video = Video.find_by(id: params[:id])
    unless @video
      video_data = YoutubeService.fetch_video_details_by_id(params[:id])
      if video_data
        video_data.delete(:category_name)
        video_data[:url] ||= "https://www.youtube.com/watch?v=#{params[:id]}"
      
        # 重複チェック
        @video = Video.find_by(url: video_data[:url]) || Video.new(video_data)
        unless @video.save
          flash[:alert] = "動画の保存に失敗しました。"
          redirect_to videos_path and return
        end
      else
        flash[:alert] = "動画が見つかりませんでした。"
        redirect_to videos_path and return
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

  def fetch_recommended_videos(video)
    recommended_videos = Video.where.not(id: video.id).limit(30)
    Rails.logger.debug "Fetched recommended videos: #{recommended_videos.map(&:id)}"
    recommended_videos
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
