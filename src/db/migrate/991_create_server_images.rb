class CreateServerImages < ActiveRecord::Migration[7.0]
  def change
    create_table :server_images do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ''
      t.string :name_id, null: false
      t.text :description, null: false, default: ''
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :server_images, [:name_id], unique: true
  end
end
