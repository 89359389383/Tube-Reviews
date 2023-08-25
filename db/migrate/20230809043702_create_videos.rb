class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title, null: false   # 修正点
      t.string :url, null: false, index: { unique: true }
      t.text :description

      t.timestamps
    end
  end
end