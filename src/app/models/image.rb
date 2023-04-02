class Image < ApplicationRecord
  belongs_to :account
  has_many :item_images
  has_many :items, through: :item_images, class_name: 'Item'
  has_one_attached :image
  validates :image, attached: true,
    size: { less_than: 10.megabytes },
    content_type: %w[ image/jpeg image/png image/gif image/webp ]
end
