class Video < ApplicationRecord
  belongs_to :account
  has_one_attached :video
  validates :video, attached: true,
    size: { less_than: 1000.megabytes },
    content_type: %w[ video/mp4 video/mpeg video/webm ]
end
