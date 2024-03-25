class Group < ApplicationRecord
  belongs_to :account
  has_many :entry
  has_many :accounts, through: :entry
  has_many :messages
end
