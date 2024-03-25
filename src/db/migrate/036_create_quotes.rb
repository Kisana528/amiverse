class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.bigint :quoted, null: false, foreign_key: true
      t.bigint :quoter, null: false, foreign_key: true
      t.timestamps
    end
    add_foreign_key :quotes, :items, column: :quoted
    add_foreign_key :quotes, :items, column: :quoter
  end
end
