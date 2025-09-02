class CreateRoutingRules < ActiveRecord::Migration[7.2]
  def change
    create_table :routing_rules do |t|
      t.string :name, null: false
      t.jsonb :conditions, default: {}
      t.references :psp, null: false, foreign_key: true
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    add_index :routing_rules, :active
  end
end
