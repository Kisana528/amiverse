class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.bigint :followed, null: false, foreign_key: true
      t.bigint :follower, null: false, foreign_key: true
      t.string :uuid, null: false, default: ''
      t.boolean :accepted, null: false, default: false
      t.timestamps
    end
    add_foreign_key :follows, :accounts, column: :followed
    add_foreign_key :follows, :accounts, column: :follower
  end
end
