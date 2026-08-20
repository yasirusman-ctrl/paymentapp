module Admin
  class UsageEntriesController < ApplicationController
    def index
      authorize UsageEntry
      @usage_entries = UsageEntry.includes(:subscription, :feature).order(created_at: :desc)
    end

    def new
      authorize UsageEntry
      @usage_entry = UsageEntry.new
      @subscriptions = Subscription.where(status: 'active').includes(:user, :plan)
      @features = Feature.all
    end

    def create
      authorize UsageEntry
      @usage_entry = UsageEntry.new(usage_entry_params)
      if @usage_entry.save
        redirect_to admin_usage_entries_path, notice: "Usage entry recorded successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def usage_entry_params
      params.require(:usage_entry).permit(:subscription_id, :feature_id, :units_used, :recorded_for_period)
    end
  end
end