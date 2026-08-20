Rails.configuration.stripe = {
  publishable_key: ENV.fetch('STRIPE_PUBLISHABLE_KEY', Rails.application.credentials.dig(:stripe, :publishable_key)),
  secret_key:      ENV.fetch('STRIPE_SECRET_KEY', Rails.application.credentials.dig(:stripe, :secret_key))
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
