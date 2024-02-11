class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.string :follow_to_id, null: false, default: ''
      t.string :follow_from_id, null: false, default: ''
      t.string :uid, null: false, default: ''
      t.boolean :accepted, null: false, default: false

      t.timestamps
    end
  end
end
