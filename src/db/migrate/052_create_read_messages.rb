class CreateReadMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :read_messages do |t|
      t.references :account, null: false, foreign_key: true
      t.references :messages, null: false, foreign_key: true
      t.timestamps
    end
  end
end
