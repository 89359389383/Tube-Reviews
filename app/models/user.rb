class User < ApplicationRecord
  # Devise設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 既存のアソシエーション
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_videos, through: :favorites, source: :video

  # フォルダに関するアソシエーション
  has_many :folders, dependent: :destroy

  # コメントに関するアソシエーション
  has_many :comments, dependent: :destroy  # dependent: :destroy を追加

  # バリデーション
  validates :name, presence: true, uniqueness: true, length: { in: 3..15 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # after_createコールバック
  after_create :create_default_folder

  private

  def create_default_folder
    folders.create(name: 'ノーマル')
  end
end
