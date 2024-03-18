class Follow < ApplicationRecord
  belongs_to :follower, foreign_key: 'follower', class_name: 'Account'
  belongs_to :followed, foreign_key: 'followed', class_name: 'Account'
end
