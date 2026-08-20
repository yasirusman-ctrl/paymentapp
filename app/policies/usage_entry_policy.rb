class UsageEntryPolicy < ApplicationPolicy
  def index?  = true
  def create? = user.admin? # Only Admin can add usage entries
end