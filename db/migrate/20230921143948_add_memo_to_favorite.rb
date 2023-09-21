class AddMemoToFavorite < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :memo, :string
  end
end
