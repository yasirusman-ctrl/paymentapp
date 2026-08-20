class Plan < ApplicationRecord
  has_many :plan_features, dependent: :destroy
  has_many :features, through: :plan_features
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true
  validates :monthly_fee, numericality: { greater_than_or_equal_to: 0 }
end
