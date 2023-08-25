class Video < ApplicationRecord
  # Associations
  has_many :reviews, dependent: :destroy
  
  # Validations
  validates :url, presence: true, uniqueness: true
  validates :title, presence: true # タイトルの存在チェック
  validates :video_id, presence: true, uniqueness: true # video_idの存在と一意性チェック
  
  # Callbacks
  before_save :extract_video_id
  
  # Search method
  def self.search(keyword)
    where("title LIKE ?", "%#{keyword}%")
  end

  private

  def extract_video_id
    match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&]+)/)
    self.video_id = match[1] if match && match[1]
  end
  
  # ... any other methods or scopes
end


