class Item < ApplicationRecord
  belongs_to :account
  has_many :account_reaction_items
  has_many :reactions, through: :account_reaction_items
  has_many_attached :images
end
