class Comment < ApplicationRecord
  # コメントは一人のユーザーに属する
  belongs_to :user

  # コメントは一つのフォルダに属する（optional: trueを削除）
  belongs_to :folder
end

