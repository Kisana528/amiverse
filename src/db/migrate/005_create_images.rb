class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.boolean :nsfw, null: false, default: false
      t.string :nsfw_message, null: false, default: ''
      t.json :meta, null: false, default: []
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :images, [:aid], unique: true
  end
end
