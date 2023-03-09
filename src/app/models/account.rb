class Account < ApplicationRecord
  has_many :items
  has_many :invitations
  include AccountImages
  include CustomVariant
  attr_accessor :remember_token, :activation_token
  validates :account_id,
    presence: true,
    length: { in: 5..25, allow_blank: true },
    uniqueness: { case_sensitive: false }
  validates :name_id,
    presence: true,
    length: { maximum: 50, allow_blank: true },
    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
    length: { maximum: 255, allow_blank: true },
    format: { with: VALID_EMAIL_REGEX, allow_blank: true },
    uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password,
    presence: true,
    length: { in: 8..63, allow_blank: true },
    allow_nil: true
  has_secure_password validations: true
  has_one_attached :icon
  has_one_attached :banner
  validate :file_type, :file_size
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  def remember(remember_token, remote_ip, user_agent, uuid)
    Session.create(account_id: self.id,
      user_agent: user_agent, remote_ip: remote_ip,
      uuid: uuid,
      session_digest: Account.digest(remember_token))
  end
  def authenticated?(uuid, token)
    return false unless session = Session.find_by(account_id: self.id, uuid: uuid, deleted: false)
    BCrypt::Password.new(session.session_digest).is_password?(token)
  end
  def forget(uuid)
    Session.find_by(account_id: self.id, uuid: uuid, deleted: false).update(deleted: true)
  end
  def resize_image(name, name_id, type)
    attachment = case type
      when 'icon' then icon
      when 'banner' then banner
      when 'header'then header
    end
    attachment.analyze if attachment.attached?
    CustomVariant.new(attachment, image_optimize(name, name_id, type)).processed
  end
  private
  def file_type
    if icon == !nil
      if !icon.blob.content_type.in?(%('image/jpeg image/png image/gif image/webp'))
        errors.add(:icon, 'は JPEG PNG GIF WEBP 形式のいずれかを選択してください。')
      end
    end
  end
  def file_size
    if icon == !nil
      if icon.blob.byte_size > 5.megabytes
        errors.add(:icon, 'は 5MB 以下のファイルを選択してください。')
      end
    end
  end
end
