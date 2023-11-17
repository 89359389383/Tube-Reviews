class User < ApplicationRecord
  # Devise設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_videos, through: :favorites, source: :video

  # バリデーション
  validates :name, presence: true, uniqueness: true, length: { in: 3..15 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # インスタンスメソッド
  def favorited?(video)
    favorite_videos.include?(video)
  end
end