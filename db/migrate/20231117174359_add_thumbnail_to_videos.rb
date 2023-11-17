class AddThumbnailToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :thumbnail, :string
  end
end
