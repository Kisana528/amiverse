class Follow < ApplicationRecord
  belongs_to :follow_from, primary_key: 'name_id', foreign_key: 'follow_from_id', class_name: 'Account'
  belongs_to :follow_to, primary_key: 'name_id', foreign_key: 'follow_to_id', class_name: 'Account'
end
