class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :video
  
  # バリデーション
  validates :user_id, uniqueness: { scope: :video_id, message: "has already favorited this video" }
end 
