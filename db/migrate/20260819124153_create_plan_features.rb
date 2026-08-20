class CreatePlanFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :plan_features do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true

      t.timestamps
    end
  end
end
