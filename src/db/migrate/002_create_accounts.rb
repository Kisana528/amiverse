class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.string :name_id, null: false
      t.string :fediverse_id, null: false, default: ''
      t.string :icon_id, null: false, default: ''
      t.string :banner_id, null: false, default: ''
      t.bigint :followers_counter, null: false, default: 0
      t.bigint :following_counter, null: false, default: 0
      t.bigint :items_counter, null: false, default: 0
      t.bigint :reactions_counter, null: false, default: 0
      t.json :pinned_items, null: false, default: []
      t.boolean :explorable, null: false, default: false
      t.json :meta, null: false, default: []
      t.json :cache, null: false, default: []
      t.json :achievements, null: false, default: []
      t.boolean :online, null: false, default: true
      t.datetime :last_online
      t.boolean :invisible_online, null: false, default: false
      t.boolean :foreigner, null: false, default: false
      t.boolean :activated, null: false, default: false
      t.boolean :administrator, null: false, default: false
      t.boolean :moderator, null: false, default: false
      t.boolean :bot, null: false, default: false
      t.boolean :commercial, null: false, default: false
      t.string :kind, null: false, default: ''
      t.boolean :discoverable, null: false, default: true
      t.boolean :manually_approves_followers, null: false, default: false
      t.text :summary, null: false, default: ''
      t.text :public_key, null: false, default: ''
      t.text :private_key, null: false, default: ''
      t.string :location, null: false, default: ''
      t.datetime :birthday
      t.json :languages, null: false, default: []
      t.string :email, null: false, default: ''
      t.boolean :locked, null: false, default: false
      t.boolean :silenced, null: false, default: false
      t.boolean :suspended, null: false, default: false
      t.boolean :frozen, null: false, default: false
      t.json :settings, null: false, default: []
      t.bigint :storage_size, null: false, default: 0
      t.bigint :storage_max_size, null: false, default: 1000000000
      t.string :password_digest
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :accounts, [:aid, :name_id, :fediverse_id], unique: true
  end
end
