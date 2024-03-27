class CreateServerLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :server_Logs do |t|
      t.string :name, null: false, default: ''
      t.text :content, null: false, default: ''
      t.timestamps
    end
  end
end
