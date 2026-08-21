class AddCurrentPeriodEndToSubscriptions < ActiveRecord::Migration[8.1]
  def up
    add_column :subscriptions, :current_period_end, :datetime

    # Backfill: set current_period_end = started_at + 1 month for existing active subs
    execute <<~SQL
      UPDATE subscriptions
      SET current_period_end = started_at + interval '1 month'
      WHERE started_at IS NOT NULL;
    SQL
  end

  def down
    remove_column :subscriptions, :current_period_end
  end
end