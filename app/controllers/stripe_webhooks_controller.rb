class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def receive
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    event = Stripe::Webhook.construct_event(
      payload, sig_header, ENV["WEBHOOK_SECRET"]
    )

    case event["type"]
    when "payment_intent.succeeded"
      payment_intent = event["data"]["object"]
      invoice = Invoice.find_by(stripe_payment_intent_id: payment_intent["id"])
      if invoice
        invoice.update!(status: "paid")
        invoice.subscription&.refresh_current_period_end!
        Rails.logger.info "Webhook: Payment #{payment_intent['id']} marked as paid."
      end

    when "payment_intent.payment_failed"
      payment_intent = event["data"]["object"]
      invoice = Invoice.find_by(stripe_payment_intent_id: payment_intent["id"])
      if invoice
        invoice.update!(status: "failed")
        subscription = invoice.subscription
        if subscription
          ExpirationMailer.payment_failed(subscription).deliver_later
          ExpirationMailer.admin_payment_failed_alert(subscription).deliver_later
        end
        Rails.logger.info "Webhook: Payment #{payment_intent['id']} marked as failed."
      end
    end

    render json: { received: true }, status: 200

  rescue Stripe::SignatureVerificationError => e
    Rails.logger.error "Webhook signature verification failed: #{e.message}"
    render json: { error: "Invalid signature" }, status: 400
  rescue JSON::ParserError => e
    Rails.logger.error "Webhook JSON parse error: #{e.message}"
    render json: { error: "Invalid payload" }, status: 400
  end
end
