class CreateAccountReactionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :account_reaction_items do |t|
      t.references :account, null: false, foreign_key: true
      t.references :reaction, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.string :description, null: false, default: ''
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
