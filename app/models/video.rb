class Video < ApplicationRecord
  # Associations
  has_many :reviews, dependent: :destroy
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  
  # Validations
  validates :url, presence: true, uniqueness: true, format: { with: URI::regexp(%w(http https)), message: 'is not a valid URL' }
  validates :title, presence: true, length: { maximum: 255, message: 'is too long (maximum is 255 characters)' }
  
  # Callbacks
  before_save :extract_video_id
  
  # Class methods
  def self.search(keyword)
    where("title LIKE ?", "%#{keyword}%")
  end

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
          category: video_data[:category]  # カテゴリ情報もここで取得
        }
      end
    rescue => e
      Rails.logger.error("YouTube API error: #{e.message}")
      []
    end
  end
  
  def self.save_category_info(video_url, category_name)
    video = find_by(url: video_url)
    video.update(category: category_name) if video
  end

  def self.save_thumbnail_info(video_url, thumbnail_url)
    video = find_by(url: video_url)
    video.update(thumbnail: thumbnail_url) if video
  end

  def self.recommended(video)
    where(category: video.category).where.not(id: video.id).order("RANDOM()").limit(30)
  end

  private

  def extract_video_id
    match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&]+)/)
    self.video_id = match[1] if match && match[1]
  end
end

class RecommendationError < StandardError; end
