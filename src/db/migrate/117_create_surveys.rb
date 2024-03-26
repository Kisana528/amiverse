class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.string :uuid, null: false
      t.integer :counter, null: false, default: 0
      t.boolean :multiple, null: false, default: false
      t.boolean :eternal, null: false, default: false
      t.json :content, null: false, default: []
      t.datetime :expires_at
      t.timestamps
    end
  end
end
