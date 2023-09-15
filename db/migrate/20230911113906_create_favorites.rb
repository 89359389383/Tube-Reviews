class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end

    # ユーザーと動画の組み合わせをユニークなインデックスとして追加
    add_index :favorites, [:user_id, :video_id], unique: true
  end
end
