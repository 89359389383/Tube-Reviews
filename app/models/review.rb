class Review < ApplicationRecord
  belongs_to :user
  belongs_to :video
  
  # Validations
  validates :title, presence: true, length: { maximum: 100 } # タイトルのバリデーションを追加
  validates :body, presence: true, length: { maximum: 500 } # :contentを:bodyに変更
  
  # 必要に応じて他のバリデーションを追加
end

