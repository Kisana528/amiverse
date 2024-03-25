class Video < ApplicationRecord
  belongs_to :account
  has_many :item_images
  has_many :items, through: :item_images, class_name: 'Item'
  has_one_attached :video
  has_one_attached :encoded_video
  validates :video, attached: true
    #size: { less_than: 10.megabytes }
    #content_type: %w[ image/jpeg image/png image/gif image/webp ]
end
