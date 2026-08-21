class CheckSubscriptionExpirationJob < ApplicationJob
  queue_as :default

  WARNING_THRESHOLDS = [7, 3, 1].freeze

  def perform
    send_expiration_warnings
    send_expired_alerts
  end

  private

  def send_expiration_warnings
    WARNING_THRESHOLDS.each do |days|
      target_date = days.days.from_now.to_date

      Subscription.where(status: "active")
        .where("current_period_end::date = ?", target_date)
        .where("last_expiration_warning_at IS NULL OR last_expiration_warning_at < ?", days.days.ago)
        .includes(:user, :plan)
        .find_each do |subscription|
          ExpirationMailer.expiration_warning(subscription, days).deliver_later
          ExpirationMailer.admin_expiration_alert(subscription, days).deliver_later
          subscription.update!(last_expiration_warning_at: Time.current)
        end
    end
  end

  def send_expired_alerts
    Subscription.where(status: "active")
      .where("current_period_end < ?", Time.current)
      .includes(:user, :plan)
      .find_each do |subscription|
        ExpirationMailer.payment_failed(subscription).deliver_later
        ExpirationMailer.admin_payment_failed_alert(subscription).deliver_later
        subscription.update!(status: "expired")
      end
  end
end
