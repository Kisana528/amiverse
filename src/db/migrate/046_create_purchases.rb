class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :account, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :uuid, null: false
      t.integer :price, null: false, default: 0
      t.integer :amount, null: false, default: 1
      t.timestamps
    end
  end
end
