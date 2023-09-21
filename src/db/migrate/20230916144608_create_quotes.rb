class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.string :quote_to_id, null: false, default: ''
      t.string :quote_from_id, null: false, default: ''

      t.timestamps
    end
  end
end
