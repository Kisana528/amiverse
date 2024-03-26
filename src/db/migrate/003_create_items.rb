class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.text :content, null: false, default: ''
      t.json :images, null: false, default: []
      t.json :audios, null: false, default: []
      t.json :videos, null: false, default: []
      t.boolean :sensitive, null: false, default: false
      t.string :warning_message, null: false, default: ''
      t.string :kind, null: false, default: ''
      t.json :meta, null: false, default: []
      t.json :cache, null: false, default: []
      t.boolean :foreign, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :items, [:aid], unique: true
  end
end
