class Reaction < ApplicationRecord
  belongs_to :account
  has_many :account_reaction_items
  has_many :items, through: :account_reaction_items
end
