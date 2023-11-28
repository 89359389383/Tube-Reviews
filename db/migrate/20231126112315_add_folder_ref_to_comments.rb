class AddFolderRefToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :folder, null: false, foreign_key: true
  end
end
