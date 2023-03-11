class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :account, null: false, foreign_key: true
      t.string :item_id, null: false
      t.string :uuid, null: false
      t.string :item_type, null: false, default: ''
      t.json :flow, null: false, default: []
      t.json :meta, null: false, default: []
      t.string :content, null: false, default: ''
      t.boolean :nsfw, null: false, default: false
      t.boolean :cw, null: false, default: false
      t.json :version, null: false, default: []
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
    add_index :items, [:item_id, :uuid], unique: true
  end
end
