class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.bigint :replied, null: false, foreign_key: true
      t.bigint :replier, null: false, foreign_key: true
      t.string :uuid, null: false, default: ''
      t.timestamps
    end
    add_foreign_key :replies, :items, column: :replied
    add_foreign_key :replies, :items, column: :replier
  end
end
