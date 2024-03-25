class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :emoji, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
