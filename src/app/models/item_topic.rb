class ItemTopic < ApplicationRecord
  belongs_to :item
  belongs_to :topic
end
