class Image < ApplicationRecord
  belongs_to :account
  has_one_attached :image
  validate :check_storage_capacity
  validates :image, attached: true,
    size: { less_than: 100.megabytes },
    content_type: %w[ image/jpeg image/png image/gif image/webp ]
  private
  def check_storage_capacity
    return unless image.attached?
    capacity = account.storage_max_size - account.storage_size
    if image.blob.byte_size > capacity
      errors.add(:image, "ストレージ容量が足りません")
    end
  end
end
