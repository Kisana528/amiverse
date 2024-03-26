class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.references :account, null: false, foreign_key: true
      t.string :uuid, null: false
      t.string :kind, null: false, default: ''
      t.string :object, null: false, default: ''
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.string :amount, null: false, default: ''
      t.timestamps
    end
  end
end
