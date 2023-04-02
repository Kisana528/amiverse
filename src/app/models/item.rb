class Item < ApplicationRecord
  belongs_to :account
  has_many :account_reaction_items
  has_many :reactions, through: :account_reaction_items
  has_many :item_images
  has_many :images, through: :item_images, class_name: 'Image'
end
