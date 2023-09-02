class ChangeReviews < ActiveRecord::Migration[7.0]
  def change
    rename_column :reviews, :content, :body
    add_column :reviews, :title, :string
  end
end
