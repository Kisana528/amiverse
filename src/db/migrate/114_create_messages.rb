class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :account, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :uuid, null: false
      t.string :kind, null: false, default: ''
      t.text :content, null: false, default: ''
      t.integer :read, null: false, default: 0
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
