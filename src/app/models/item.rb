class Item < ApplicationRecord
  belongs_to :account
  has_many :replies
  has_many :quotes
  has_many :reply_from, class_name: 'Reply', primary_key: 'item_id', foreign_key: 'reply_from_id'
  has_many :reply_to, class_name: 'Reply', primary_key: 'item_id', foreign_key: 'reply_to_id'
  has_many :reply_from_items, through: :reply_to, source: :reply_from
  has_many :reply_to_items, through: :reply_from, source: :reply_to
  has_many :quote_from, class_name: 'Quote', primary_key: 'item_id', foreign_key: 'quote_from_id'
  has_many :quote_to, class_name: 'Quote', primary_key: 'item_id', foreign_key: 'quote_to_id'
  has_many :quote_from_items, through: :quote_to, source: :quote_from
  has_many :quote_to_items, through: :quote_from, source: :quote_to
  has_many :account_reaction_items
  has_many :reactions, through: :account_reaction_items
  has_many :item_images
  has_many :images, through: :item_images, class_name: 'Image'
end
