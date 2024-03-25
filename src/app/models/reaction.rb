class Reaction < ApplicationRecord
  belongs_to :account
  belongs_to :emoji
  belongs_to :item
end
