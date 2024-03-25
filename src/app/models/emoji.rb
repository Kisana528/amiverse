class Emoji < ApplicationRecord
  belongs_to :account
  has_many :reaction
  has_many :items, through: :reaction
end
