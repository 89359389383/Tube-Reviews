class AddThumbnailUrlToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :thumbnail_url, :string
  end
end
