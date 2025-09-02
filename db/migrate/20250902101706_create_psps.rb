class CreatePsps < ActiveRecord::Migration[7.2]
  def change
    create_table :psps do |t|
      t.string :name, null: false
      t.string :psp_type, null: false
      t.jsonb :endpoints, default: {}
      t.jsonb :auth, default: {}
      t.jsonb :credentials, default: {}
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    add_index :psps, :name, unique: true
  end
end
