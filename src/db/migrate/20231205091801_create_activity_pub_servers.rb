class CreateActivityPubServers < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_pub_servers do |t|
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
