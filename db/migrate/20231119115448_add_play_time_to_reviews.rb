class AddPlayTimeToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :play_time, :float
  end
end
