class Folder < ApplicationRecord
  belongs_to :user

  # Review と Comment モデルへの関連付けに dependent: :destroy オプションを追加
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
end

