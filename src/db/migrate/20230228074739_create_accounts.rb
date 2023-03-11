class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :account_id, null: false
      t.string :name, null: false, default: ''
      t.string :name_id, null: false
      t.string :online_status, null: false, default: ''
      t.timestamp :last_online
      t.boolean :open_online_status, null: false, default: true
      t.boolean :authenticated, null: false, default: false
      t.boolean :public_visibility, null: false, default: true
      t.json :local_group_visibility, null: false, default: []
      t.json :local_account_visibility, null: false, default: []
      t.json :role, null: false, default: []
      t.boolean :activated, null: false, default: false
      t.boolean :administrator, null: false, default: false
      t.boolean :moderator, null: false, default: false
      t.string :email, null: false, default: ''
      t.string :bio, null: false, default: ''
      t.string :location, null: false, default: ''
      t.timestamp :birthday
      t.json :lang, null: false, default: []
      t.integer :followers, null: false, default: 0
      t.integer :following, null: false, default: 0
      t.integer :items_count, null: false, default: 0
      t.json :pinned_items, null: false, default: []
      t.boolean :nsfw, null: false, default: false
      t.boolean :explorable, null: false, default: false
      t.json :profile, null: false, default: []
      t.json :achievements, null: false, default: []
      t.boolean :locked, null: false, default: false
      t.boolean :silenced, null: false, default: false
      t.boolean :suspended, null: false, default: false
      t.boolean :frozen, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.json :settings, null: false, default: []
      t.string :password_digest
      t.bigint :storage_size, null: false, default: 0
      t.bigint :storage_max_size, null: false, default: 1000000000
      t.timestamps
    end
    add_index :accounts, [:account_id, :name_id, :email], unique: true
  end
end
