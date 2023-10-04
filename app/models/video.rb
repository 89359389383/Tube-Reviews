class Video < ApplicationRecord
  # Associations
  has_many :reviews, dependent: :destroy
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  
  # Validations
  validates :url, presence: true, uniqueness: true
  validates :title, presence: true
  
  # Callbacks
  before_save :extract_video_id  # この行はそのままで良い場合
  
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

  # Private methods
  private

  def extract_video_id
    match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&]+)/)
    self.video_id = match[1] if match && match[1]
  end
end
