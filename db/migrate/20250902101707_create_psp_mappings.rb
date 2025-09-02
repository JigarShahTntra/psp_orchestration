class CreatePspMappings < ActiveRecord::Migration[7.2]
  def change
    create_table :psp_mappings do |t|
      t.references :psp, null: false, foreign_key: true
      t.jsonb :request_templates, default: {}
      t.jsonb :response_templates, default: {}

      t.timestamps
    end
  end
end
