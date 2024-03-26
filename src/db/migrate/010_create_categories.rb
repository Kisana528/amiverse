class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.bigint :counter, null: false, default: 0
      t.timestamps
    end
    add_index :categories, [:aid], unique: true
  end
end
