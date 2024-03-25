class CreateEmojis < ActiveRecord::Migration[7.0]
  def change
    create_table :emojis do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :emoji_type, null: false, default: ''
      t.string :content, null: false, default: ''
      t.string :description, null: false, default: ''
      t.boolean :sensitive, null: false, default: false
      t.boolean :local, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :emojis, [:aid], unique: true
  end
end
