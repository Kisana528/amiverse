class Quote < ApplicationRecord
  belongs_to :quote_from, primary_key: 'item_id', foreign_key: 'quote_from_id', class_name: 'Item'
  belongs_to :quote_to, primary_key: 'item_id', foreign_key: 'quote_to_id', class_name: 'Item'
end
