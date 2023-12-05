class CreateActivityPubDelivereds < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_pub_delivereds do |t|
      t.integer :server_id
      t.string :host
      t.string :path
      t.string :digest
      t.text :signature
      t.json :content
      t.text :response

      t.timestamps
    end
  end
end
