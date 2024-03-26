class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :account, null: false, foreign_key: true
      t.string :uuid, null: false
      t.integer :counter, null: false, default: 0
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :content, null: false, default: ''
      t.integer :purchases, null: false, default: 0
      t.integer :max_purchases, null: false, default: 1
      t.integer :price, null: false, default: 0
      t.datetime :expires_at
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
