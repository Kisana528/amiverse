class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ''
      t.string :invitation_code, null: false
      t.integer :uses, null: false, default: 0
      t.integer :max_uses, null: false, default: 1
      t.datetime :expires_at
      t.boolean :deleted, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :invitations, [:invitation_code], unique: true
  end
end
