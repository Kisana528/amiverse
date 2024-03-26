class Image < ApplicationRecord
  belongs_to :account
  has_one_attached :image
  validates :image, attached: true,
    size: { less_than: 100.megabytes },
    content_type: %w[ image/jpeg image/png image/gif image/webp ]
end
