class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_many :usage_entries, dependent: :destroy
  has_many :invoices, dependent: :nullify
end
