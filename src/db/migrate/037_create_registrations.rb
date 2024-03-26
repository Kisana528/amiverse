class CreateRegistrations < ActiveRecord::Migration[7.0]
  def change
    create_table :registrations do |t|
      t.references :account, null: false, foreign_key: true
      t.string :list, null: false, default: ''
      t.timestamps
    end
  end
end
