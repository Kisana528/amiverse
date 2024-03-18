class CreateItemImages < ActiveRecord::Migration[7.0]
  def change
    create_table :item_images do |t|
      t.references :item, null: false, foreign_key: true
      t.references :image, null: false, foreign_key: true
      t.string :description, null: false, default: ''
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
