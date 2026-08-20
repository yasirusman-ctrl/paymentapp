class Feature < ApplicationRecord
  has_many :plan_features, dependent: :destroy
  has_many :plans, through: :plan_features
  has_many :usage_entries, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :max_unit_limit, numericality: { greater_than_or_equal_to: 0 }
end
