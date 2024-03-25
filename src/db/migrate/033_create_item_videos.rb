class CreateItemVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :item_videos do |t|
      t.references :item, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.timestamps
    end
  end
end
