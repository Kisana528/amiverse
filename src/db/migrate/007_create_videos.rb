class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.references :account, null: false, foreign_key: true
      t.string :video_id, null: false
      t.string :uuid, null: false
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.boolean :nsfw, null: false, default: false
      t.string :nsfw_message, null: false, default: ''
      t.boolean :public_visibility, null: false, default: true
      t.json :local_group_visibility, null: false, default: []
      t.json :local_account_visibility, null: false, default: []
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
    add_index :videos, [:video_id, :uuid], unique: true
  end
end
