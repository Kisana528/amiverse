class CreateActivityPubReceiveds < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_pub_receiveds do |t|
      t.integer :server_id
      t.string :received_at
      t.json :headers
      t.json :body

      t.timestamps
    end
  end
end
