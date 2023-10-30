class Video < ApplicationRecord
  # Associations
  has_many :reviews, dependent: :destroy
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  
  # Validations
  validates :url, presence: true, uniqueness: true, format: { with: URI::regexp(%w(http https)), message: 'is not a valid URL' }  # URLのフォーマットを検証
  validates :title, presence: true, length: { maximum: 255, message: 'is too long (maximum is 255 characters)' }  # タイトルの長さを検証
  
  # Callbacks
  before_save :extract_video_id
  
  # Class methods
  def self.search(keyword)
    where("title LIKE ?", "%#{keyword}%")
  end

  def self.search_from_youtube(keyword)
    begin
      Rails.logger.debug "Searching YouTube API for: #{keyword}"
      search_results = YoutubeService.search_videos(keyword)
      search_results.map do |item|
        {
          title: item[:title],
          description: item[:description],
          url: "https://www.youtube.com/watch?v=#{item[:video_id]}",
          thumbnail_url: item[:thumbnail_url],
          published_at: item[:published_at]
        }
      end
    rescue => e
      Rails.logger.error("YouTube API error: #{e.message}")
      []
    end
  end
  
  def self.save_category_info(video_url, category_name)
    video = find_by(url: video_url)
    if video
      video.update(category: category_name)
    end
  end

  def self.save_thumbnail_info(video_url, thumbnail_url)
    video = find_by(url: video_url)
    if video
      video.update(thumbnail: thumbnail_url)
    else
      create(url: video_url, thumbnail: thumbnail_url)
    end
  end

  def self.recommended(video)
    category = video.category
    where(category: category).where.not(id: video.id).order("RANDOM()").limit(5)
  end

  private

  def extract_video_id
    match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&]+)/)
    self.video_id = match[1] if match && match[1]
  end
end
