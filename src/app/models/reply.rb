class Reply < ApplicationRecord
  belongs_to :reply_from, primary_key: 'item_id', foreign_key: 'reply_from_id', class_name: 'Item'
  belongs_to :reply_to, primary_key: 'item_id', foreign_key: 'reply_to_id', class_name: 'Item'
end
