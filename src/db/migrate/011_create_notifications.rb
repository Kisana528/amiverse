class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :account, null: false, foreign_key: true
      t.string :uuid, null: false
      t.string :kind, null: false, default: ''
      t.string :object, null: false, default: ''
      t.string :message, null: false, default: ''
      t.boolean :read, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
