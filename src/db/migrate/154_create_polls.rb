class CreatePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :Polls do |t|
      t.references :account, null: false, foreign_key: true
      t.references :survey, null: false, foreign_key: true
      t.json :content, null: false, default: []
      t.timestamps
    end
  end
end
