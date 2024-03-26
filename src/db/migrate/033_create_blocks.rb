class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.bigint :blocked, null: false, foreign_key: true
      t.bigint :blocker, null: false, foreign_key: true
      t.timestamps
    end
    add_foreign_key :blocks, :accounts, column: :blocked
    add_foreign_key :blocks, :accounts, column: :blocker
  end
end
