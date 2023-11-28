class AddFolderIdToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :folder_id, :integer
  end
end
