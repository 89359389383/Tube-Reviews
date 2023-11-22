class Review < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :body, presence: true, length: { maximum: 500 }

  # 追加: play_time 属性のバリデーション
  validates :play_time, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :recent, -> { order(created_at: :desc) }
end
