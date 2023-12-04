class Video < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user

  validates :url, presence: true, uniqueness: true, format: { with: URI::regexp(%w(http https)), message: 'is not a valid URL' }
  validates :title, presence: true, length: { maximum: 255, message: 'is too long (maximum is 255 characters)' }

  before_save :extract_video_id

  # 検索メソッド
  def self.search(keyword, page = 1, per_page = 20)
    offset = (page - 1) * per_page
    where("title LIKE ?", "%#{keyword}%").limit(per_page).offset(offset)
  end

  # YouTube APIからの検索
  def self.search_from_youtube(keyword, max_results = 20)
    begin
      Rails.logger.debug "Searching YouTube API for: #{keyword}"
      search_results = YoutubeService.search_videos(keyword, max_results)
      search_results.map do |video_data|
        {
          title: video_data[:title],
          description: video_data[:description],
          url: "https://www.youtube.com/watch?v=#{video_data[:video_id]}",
          thumbnail_url: video_data[:thumbnail_url],
          published_at: video_data[:published_at],
          duration: video_data[:duration],
          view_count: video_data[:view_count],
          channel_title: video_data[:channel_title],
          category: video_data[:category]
        }
      end
    rescue => e
      Rails.logger.error("YouTube API error: #{e.message}")
      []
    end
  end

  # カテゴリとサムネイルの保存
  def self.save_category_info(video_url, category_name)
    video = find_by(url: video_url)
    video.update(category: category_name) if video
  end

  def self.save_thumbnail_info(video_url, thumbnail_url)
    video = find_by(url: video_url)
    video.update(thumbnail: thumbnail_url) if video
  end

  # おすすめ動画の取得
  def self.recommended(video, page = 1, per_page = 30)
    offset = (page - 1) * per_page
    where(category: video.category).where.not(id: video.id).order("RANDOM()").limit(per_page).offset(offset)
  end

  private

  # 動画IDの抽出
  def extract_video_id
    match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&]+)/)
    self.video_id = match[1] if match && match[1]
  end
end
