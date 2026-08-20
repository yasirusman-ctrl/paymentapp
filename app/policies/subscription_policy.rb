class SubscriptionPolicy < ApplicationPolicy
  def index?  = true
  def create? = user.buyer? && user.payment_authorized? # Blocked if payment not authorized!
  def show?   = user.admin? || record.user_id == user.id
end