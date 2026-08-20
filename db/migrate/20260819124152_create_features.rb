class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features do |t|
      t.string :name
      t.string :code
      t.decimal :unit_price
      t.integer :max_unit_limit

      t.timestamps
    end
  end
end
