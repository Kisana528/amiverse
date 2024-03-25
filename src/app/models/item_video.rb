class ItemVideo < ApplicationRecord
  belongs_to :item
  belongs_to :video
end
