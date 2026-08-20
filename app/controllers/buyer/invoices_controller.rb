module Buyer
  class InvoicesController < ApplicationController
    def index
      @invoices = current_user.invoices.order(created_at: :desc)
    end

    def show
      @invoice = current_user.invoices.find(params[:id])
    end
  end
end
