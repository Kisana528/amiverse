class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :uuid, null: false
      t.integer :counter, null: false, default: 0
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
