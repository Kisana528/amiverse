class CreateItemTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :item_topics do |t|
      t.references :item, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.integer :score, null: false, default: 0
      t.timestamps
    end
  end
end
