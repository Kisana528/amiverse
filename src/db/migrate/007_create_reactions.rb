class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :reaction_id, null: false
      t.string :reaction_type, null: false, default: ''
      t.string :content, null: false, default: ''
      t.string :description, null: false, default: ''
      t.string :category, null: false, default: ''
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
