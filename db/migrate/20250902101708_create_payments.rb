class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.integer :amount_cents, null: false
      t.string :currency, null: false
      t.string :status, null: false, default: "pending"
      t.integer :psp_id
      t.string :external_id
      t.jsonb :metadata, default: {}

      t.timestamps
    end
    add_index :payments, :psp_id
    add_index :payments, :external_id
  end
end
