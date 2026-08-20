class CreateUsageEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :usage_entries do |t|
      t.references :subscription, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.integer :units_used
      t.date :recorded_for_period

      t.timestamps
    end
  end
end
