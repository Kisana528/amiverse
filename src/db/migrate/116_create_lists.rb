class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.integer :counter, null: false, default: 0
      t.timestamps
    end
    add_index :lists, [:aid], unique: true
  end
end
