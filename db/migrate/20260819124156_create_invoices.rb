class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :charge_type
      t.string :stripe_payment_intent_id
      t.string :status

      t.timestamps
    end
  end
end
