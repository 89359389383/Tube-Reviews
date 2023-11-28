class Folder < ApplicationRecord
  # User モデルへの関連付け
  belongs_to :user

  # Comment モデルへの関連付け
  has_many :comments
end

