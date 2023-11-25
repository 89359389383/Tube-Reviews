class AddDetailsToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :duration, :string
    add_column :videos, :view_count, :integer
    add_column :videos, :channel_title, :string
  end
end
