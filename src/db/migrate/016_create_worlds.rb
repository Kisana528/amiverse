class CreateWorlds < ActiveRecord::Migration[7.0]
  def change
    create_table :worlds do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.bigint :players, null: false, default: 0
      t.bigint :max_players, null: false, default: 8
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :worlds, [:aid], unique: true
  end
end
