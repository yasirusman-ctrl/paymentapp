CheckSubscriptionExpirationJob.perform_nowclass AddLastExpirationWarningAtToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :last_expiration_warning_at, :datetime
  end
end
