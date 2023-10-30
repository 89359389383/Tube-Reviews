class AddCategoryToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :category, :string
  end
end
