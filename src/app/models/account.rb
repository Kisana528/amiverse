class Account < ApplicationRecord
  has_many :items
  has_many :images
  has_many :invitations
  has_many :reaction
  has_many :account_reaction_items
  attr_accessor :remember_token, :activation_token
  validates :account_id,
    presence: true,
    length: { in: 5..25, allow_blank: true },
    uniqueness: { case_sensitive: false }
  validates :name_id,
    presence: true,
    length: { in: 5..50, allow_blank: true },
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
  validates :icon,
    size: { less_than: 1.megabytes },
    content_type: %w[ image/jpeg image/png image/gif image/webp ]
  has_one_attached :banner
  validates :banner,
    size: { less_than: 1.megabytes },
    content_type: %w[ image/jpeg image/png image/gif image/webp ]
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
  private
end
