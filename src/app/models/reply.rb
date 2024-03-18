class Reply < ApplicationRecord
  belongs_to :replier, foreign_key: 'replier', class_name: 'Item'
  belongs_to :replied, foreign_key: 'replied', class_name: 'Item'
end
