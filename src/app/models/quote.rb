class Quote < ApplicationRecord
  belongs_to :quoter, foreign_key: 'quoter', class_name: 'Item'
  belongs_to :quoted, foreign_key: 'quoted', class_name: 'Item'
end
