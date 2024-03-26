class CreateEmojiCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :emoji_categories do |t|
      t.references :emoji, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
