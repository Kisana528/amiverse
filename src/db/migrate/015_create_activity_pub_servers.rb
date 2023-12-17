class CreateActivityPubServers < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_pub_servers do |t|
      t.string :server_id, null: false, default: ''
      t.string :name, null: false, default: ''
      t.string :host, null: false, default: ''
      t.text :description, null: false, default: ''
      t.string :icon_url, null: false, default: ''
      t.string :favicon_id, null: false, default: ''
      t.integer :accounts, null: false, default: 0
      t.integer :items, null: false, default: 0
      t.integer :followers, null: false, default: 0
      t.integer :following, null: false, default: 0
      t.string :memo, null: false, default: ''
      t.string :software_name, null: false, default: ''
      t.string :software_version, null: false, default: ''
      t.boolean :open_registrations, null: false, default: false
      t.boolean :not_responding, null: false, default: false
      t.boolean :blocked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :theme_color, null: false, default: ''
      t.string :maintainer_name, null: false, default: ''
      t.string :maintainer_email, null: false, default: ''
      t.timestamp :first_retrieved_at
      t.timestamp :last_received_at
      t.timestamp :info_updated_at

      t.timestamps
    end
    add_index :activity_pub_servers, [:server_id, :host], unique: true
  end
end
