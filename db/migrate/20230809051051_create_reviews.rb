class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.text :comment # この名前は後で変更されるため、最初からcontentとしても良い
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end
  end
end