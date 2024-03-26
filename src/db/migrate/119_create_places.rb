class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.references :account, null: false, foreign_key: true
      t.string :uuid, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :counter, null: false, default: 0
      t.string :name, null: false, default: ''
      t.boolean :private, null: false, default: false
      t.timestamps
    end
  end
end
