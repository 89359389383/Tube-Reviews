class Video < ApplicationRecord
  # Associations
  has_many :reviews, dependent: :destroy
  
  # Validations
  validates :url, presence: true, uniqueness: true
  validates :title, presence: true
  validates :video_id, presence: true, uniqueness: true
  
  # Callbacks
  before_save :extract_video_id
  
  # Class methods
  def self.search(keyword)
    where("title LIKE ?", "%#{keyword}%")
  end

  def self.search_from_youtube(keyword)
    begin
      Rails.logger.debug "Searching YouTube API for: #{keyword}"
      search_response = YOUTUBE_SERVICE.list_searches('snippet', q: keyword, max_results: 10)
      search_response.items.map do |item|
        {
          title: item.snippet.title,
          description: item.snippet.description,
          url: "https://www.youtube.com/watch?v=#{item.id.video_id}"
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
