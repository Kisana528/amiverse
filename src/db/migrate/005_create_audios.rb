class CreateAudios < ActiveRecord::Migration[7.0]
  def change
    create_table :audios do |t|
      t.references :account, null: false, foreign_key: true
      t.string :aid, null: false
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.boolean :sensitive, null: false, default: false
      t.string :warning_message, null: false, default: ''
      t.string :kind, null: false, default: ''
      t.json :meta, null: false, default: []
      t.json :cache, null: false, default: []
      t.json :references, null: false, default: []
      t.boolean :permission_scope, null: false, default: false
      t.boolean :private, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :audios, [:aid], unique: true
  end
end
