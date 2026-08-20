module Buyer
  class SubscriptionsController < ApplicationController
    def index
      @subscriptions = current_user.subscriptions.includes(:plan)
    end

    def new
      unless current_user.payment_authorized?
        redirect_to new_buyer_payment_method_path, alert: "You must authorize a payment method before subscribing to any plan."
        return
      end
      @subscription = Subscription.new
      @plans = Plan.all
    end

    def create
      authorize Subscription
      @plan = Plan.find(params[:subscription][:plan_id])

      # Retrieve customer's default payment method
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      default_pm = customer.invoice_settings.default_payment_method

      # Fallback: if default_pm is nil, fetch customer's attached payment methods
      if default_pm.blank?
        payment_methods = Stripe::PaymentMethod.list({ customer: current_user.stripe_customer_id, type: 'card' })
        default_pm = payment_methods.data.first&.id
      end

      unless default_pm.present?
        current_user.update(payment_authorized: false)
        redirect_to new_buyer_payment_method_path, alert: "No authorized payment method found. Please authorize your card."
        return
      end

      # Charge customer for first month plan fee
      charge = Stripe::PaymentIntent.create({
        amount: (@plan.monthly_fee * 100).to_i, # cents
        currency: 'usd',
        customer: current_user.stripe_customer_id,
        payment_method: default_pm,
        confirm: true,
        off_session: true
      })

      @subscription = current_user.subscriptions.create!(plan: @plan, status: 'active', started_at: Time.current)
      invoice = current_user.invoices.create!(
        subscription: @subscription,
        total_amount: @plan.monthly_fee,
        charge_type: 'subscription_creation',
        stripe_payment_intent_id: charge.id,
        status: 'paid'
      )

      # Send email invoice
      begin
        InvoiceMailer.send_receipt(invoice).deliver_later
      rescue StandardError => e
        Rails.logger.warn "Mailer warning: #{e.message}"
      end

      redirect_to buyer_subscriptions_path, notice: "Subscribed to #{@plan.name} successfully! Monthly fee charged and invoice emailed."
    rescue Stripe::StripeError => e
      redirect_to new_buyer_subscription_path, alert: "Payment failed: #{e.message}"
    end
  end
end