class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ''
      t.string :ip_address, null: false, default: ''
      t.string :user_agent, null: false, default: ''
      t.string :uuid, null: false
      t.string :session_digest, null: false
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :sessions, [:uuid], unique: true
  end
end
