class Review < ApplicationRecord
  belongs_to :user
  belongs_to :video
  
  # Validations
  validates :content, presence: true, length: { maximum: 500 } # 感想の内容が存在し、500文字以下であることのバリデーション
  # 必要に応じて他のバリデーションを追加
end
