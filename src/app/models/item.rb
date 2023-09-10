class Item < ApplicationRecord
  belongs_to :account
  belongs_to :item, primary_key: 'item_id', foreign_key: 'reply_item_id', optional: true
  has_many :items, primary_key: 'item_id', foreign_key: 'reply_item_id'
  has_many :account_reaction_items
  has_many :reactions, through: :account_reaction_items
  has_many :item_images
  has_many :images, through: :item_images, class_name: 'Image'
end
