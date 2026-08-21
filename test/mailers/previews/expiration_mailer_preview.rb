class ExpirationMailerPreview < ActionMailer::Preview
  def expiration_warning
    subscription = Subscription.first || Subscription.new(
      user: User.new(email: "test@example.com", name: "Test User"),
      plan: Plan.new(name: "Basic", monthly_fee: 29.99),
      current_period_end: 7.days.from_now,
      status: "active"
    )
    ExpirationMailer.expiration_warning(subscription, 7)
  end

  def payment_failed
    subscription = Subscription.first || Subscription.new(
      user: User.new(email: "test@example.com", name: "Test User"),
      plan: Plan.new(name: "Basic", monthly_fee: 29.99),
      status: "active"
    )
    ExpirationMailer.payment_failed(subscription)
  end

  def admin_expiration_alert
    subscription = Subscription.first || Subscription.new(
      user: User.new(email: "test@example.com", name: "Test User"),
      plan: Plan.new(name: "Basic", monthly_fee: 29.99),
      current_period_end: 3.days.from_now,
      status: "active"
    )
    ExpirationMailer.admin_expiration_alert(subscription, 3)
  end

  def admin_payment_failed_alert
    subscription = Subscription.first || Subscription.new(
      user: User.new(email: "test@example.com", name: "Test User"),
      plan: Plan.new(name: "Basic", monthly_fee: 29.99),
      status: "active"
    )
    ExpirationMailer.admin_payment_failed_alert(subscription)
  end
end
