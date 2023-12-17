class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.string :reply_to_id, null: false, default: ''
      t.string :reply_from_id, null: false, default: ''

      t.timestamps
    end
  end
end
