module Buyer
  class PaymentMethodsController < ApplicationController
    def new
      unless current_user.stripe_customer_id.present?
        stripe_customer = Stripe::Customer.create(email: current_user.email, name: current_user.name)
        current_user.update!(stripe_customer_id: stripe_customer.id)
      end

      @setup_intent = Stripe::SetupIntent.create(customer: current_user.stripe_customer_id)
    end

    def create
      if params[:payment_method_id].present?
        pm_id = params[:payment_method_id]

        # Attach payment method to Customer in Stripe
        Stripe::PaymentMethod.attach(pm_id, { customer: current_user.stripe_customer_id })

        # Set as default payment method for future off-session charges
        Stripe::Customer.update(
          current_user.stripe_customer_id,
          { invoice_settings: { default_payment_method: pm_id } }
        )

        current_user.update!(payment_authorized: true)
        redirect_to buyer_subscriptions_path, notice: "Payment method authorized successfully! You can now subscribe to plans."
      else
        redirect_to new_buyer_payment_method_path, alert: "Payment authorization failed."
      end
    rescue Stripe::StripeError => e
      redirect_to new_buyer_payment_method_path, alert: "Stripe error: #{e.message}"
    end
  end
end