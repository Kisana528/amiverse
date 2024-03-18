class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :account, null: false, foreign_key: true
      t.string :item_id, null: false
      t.string :uuid, null: false
      t.string :item_type, null: false, default: ''
      t.string :reply_item_id, null: false, default: ''
      t.string :quote_item_id, null: false, default: ''
      t.json :meta, null: false, default: []
      t.text :content, null: false, default: ''
      t.boolean :markdown, null: false, default: false
      t.boolean :html, null: false, default: false
      t.boolean :cw, null: false, default: false
      t.string :cw_message, null: false, default: ''
      t.json :version, null: false, default: []
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :items, [:item_id, :uuid], unique: true
  end
end
