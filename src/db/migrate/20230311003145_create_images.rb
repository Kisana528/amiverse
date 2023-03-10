class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.references :account, null: false, foreign_key: true
      t.string :image_id, null: false
      t.string :uuid, null: false
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.string :visibility, null: false, default: ''
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
    add_index :images, [:image_id, :uuid], unique: true
  end
end
