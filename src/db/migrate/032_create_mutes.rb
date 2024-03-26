class CreateMutes < ActiveRecord::Migration[7.0]
  def change
    create_table :mutes do |t|
      t.bigint :muted, null: false, foreign_key: true
      t.bigint :muter, null: false, foreign_key: true
      t.timestamps
    end
    add_foreign_key :mutes, :accounts, column: :muted
    add_foreign_key :mutes, :accounts, column: :muter
  end
end
