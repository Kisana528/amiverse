class CreateActivityPubReceiveds < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_pub_receiveds do |t|
      t.integer :server_id
      t.string :received_at
      t.json :headers
      t.json :body
      t.json :context #-
      t.string :activitypub_id
      t.string :account_id
      t.string :activity_type
      t.json :object
      t.text :summary
      t.string :status

      t.timestamps
    end
  end
end
