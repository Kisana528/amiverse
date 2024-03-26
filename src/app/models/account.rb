class Account < ApplicationRecord
  has_many :sessions
  has_many :invitations
  has_many :items
  has_many :images
  has_many :videos
  has_many :emojis
  has_many :reactions
  has_many :messages
  has_many :notifications
  # follow
  has_many :followed, class_name: 'Follow', foreign_key: 'followed'
  has_many :follower, class_name: 'Follow', foreign_key: 'follower'
  has_many :followers, through: :followed, source: :follower
  has_many :following, through: :follower, source: :followed
  # --- #
  attr_accessor :remember_token, :activation_token
  BASE_64_URL_REGEX  = /\A[a-zA-Z0-9_-]*\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :aid,
    presence: true,
    length: { in: 5..25, allow_blank: true },
    uniqueness: { case_sensitive: false }
  with_options unless: -> { validation_context == :skip } do
    validates :name_id,
      presence: true,
      length: { in: 5..50, allow_blank: true },
      format: { with: BASE_64_URL_REGEX, allow_blank: true },
      uniqueness: { case_sensitive: false }
    validate :image_id_presence
    validates :icon_id,
      format: { with: BASE_64_URL_REGEX, allow_blank: true }
    validates :banner_id,
      format: { with: BASE_64_URL_REGEX, allow_blank: true }
    validates :email,
      length: { maximum: 255, allow_blank: true },
      format: { with: VALID_EMAIL_REGEX, allow_blank: true },
      uniqueness: { case_sensitive: false, allow_blank: true }
    validates :password,
      presence: true,
      length: { in: 8..63, allow_blank: true },
      allow_nil: true
    validate do |record|
      record.errors.add(:password, :blank) unless record.password_digest.present?
    end
    validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    validates_confirmation_of :password, allow_blank: true
  end
  has_secure_password validations: false

  def authenticated?(uuid, token)
    return false unless session = Session.find_by(account_id: self.id, uuid: uuid, deleted: false)
    BCrypt::Password.new(session.session_digest).is_password?(token)
  end
  def forget(uuid)
    Session.find_by(account_id: self.id, uuid: uuid, deleted: false).update(deleted: true)
  end
  private
  def image_id_presence
    if icon_id.present?
      unless Image.exists?(image_id: icon_id)
        errors.add(:base, '存在しないicon')
      end
    end
    if banner_id.present?
      unless Image.exists?(image_id: banner_id)
        errors.add(:base, '存在しないbanner')
      end
    end
  end
end
