class Review < ApplicationRecord
  belongs_to :user
  belongs_to :video
  
  # Validations
  validates :body, presence: true, length: { minimum: 5, maximum: 500 } # 本文の存在性と文字数の制限
  
  # スコープ: レビューを作成した日時でソート
  scope :recent, -> { order(created_at: :desc) }
end