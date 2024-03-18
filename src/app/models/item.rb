class Item < ApplicationRecord
  belongs_to :account
  # reply
  has_many :replied, class_name: 'Reply', foreign_key: 'replied'
  has_many :replier, class_name: 'Reply', foreign_key: 'replier'
  has_many :repliers, through: :replied, source: :replier
  has_many :replying, through: :replier, source: :replied
  # quote
  has_many :quoted, class_name: 'Quote', foreign_key: 'quoted'
  has_many :quoter, class_name: 'Quote', foreign_key: 'quoter'
  has_many :quoters, through: :quoted, source: :quoter
  has_many :quoting, through: :quoter, source: :quoted
  # --- #
  has_many :account_reaction_items
  has_many :reactions, through: :account_reaction_items
  has_many :item_images
  has_many :images, through: :item_images
  has_many :item_videos
  has_many :videos, through: :item_videos
end
