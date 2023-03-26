class AccountReactionItem < ApplicationRecord
  belongs_to :account
  belongs_to :reaction
  belongs_to :item
end
