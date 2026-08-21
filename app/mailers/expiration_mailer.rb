class ExpirationMailer < ApplicationMailer
  default from: "noreply@demomailtrap.co"

  def expiration_warning(subscription, days_left)
    @subscription = subscription
    @user = subscription.user
    @plan = subscription.plan
    @days_left = days_left
    @current_period_end = subscription.current_period_end

    mail(
      to: @user.email,
      subject: "Your #{@plan.name} plan expires in #{days_left} day#{'s' if days_left > 1}"
    )
  end

  def payment_failed(subscription)
    @subscription = subscription
    @user = subscription.user
    @plan = subscription.plan

    mail(
      to: @user.email,
      subject: "Payment failed for your #{@plan.name} plan"
    )
  end

  def admin_expiration_alert(subscription, days_left)
    @subscription = subscription
    @user = subscription.user
    @plan = subscription.plan
    @days_left = days_left
    @current_period_end = subscription.current_period_end

    mail(
      to: admin_emails,
      subject: "[Alert] #{@user.email}'s #{@plan.name} plan expires in #{days_left} day#{'s' if days_left > 1}"
    )
  end

  def admin_payment_failed_alert(subscription)
    @subscription = subscription
    @user = subscription.user
    @plan = subscription.plan

    mail(
      to: admin_emails,
      subject: "[Alert] Payment failed for #{@user.email}'s #{@plan.name} plan"
    )
  end

  private

  def admin_emails
    ["yasir.usman@devsinc.com"]
  end
end
