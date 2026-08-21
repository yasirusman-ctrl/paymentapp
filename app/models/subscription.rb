class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_many :usage_entries, dependent: :destroy
  has_many :invoices, dependent: :nullify

  def refresh_current_period_end!
    update!(current_period_end: 1.month.from_now)
  end
end