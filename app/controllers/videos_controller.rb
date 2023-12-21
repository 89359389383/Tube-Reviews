class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show]

  def index
    sort_order = params[:sort] == 'newest' ? :desc : :asc
    @videos = Video.all.order(published_at: sort_order).page(params[:page]).per(20)
    @from_database = true

    respond_to do |format|
      format.html # 通常のHTML応答
      # format.js   # JavaScriptリクエスト（Ajax）に対する応答（もし必要なら）
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
    unless @video
      video_data = YoutubeService.fetch_video_details_by_id(params[:id])
      if video_data
        @video = Video.new(video_data)
        @video.save # ここでデータベースに保存
      else
        redirect_to videos_path, alert: "動画が見つかりませんでした。"
        return
      end
    end

    @video_details = @video
    @reviews = @video.reviews.order(created_at: :desc) if @video.reviews
    @recommended_videos = Video.recommended(@video)

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
        @video = Video.find_by(url: video_data[:url])
        unless @video
          @video = Video.new(video_data)
          unless @video.save
            Rails.logger.debug @video.errors.full_messages
            flash[:alert] = "動画の保存に失敗しました。"
            redirect_to videos_path and return
          end
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

