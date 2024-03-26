class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.references :account, null: false, foreign_key: true
      t.references :membership, null: false, foreign_key: true
      t.string :uuid, null: false
      t.datetime :expires_at
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
