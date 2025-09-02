# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Psp.destroy_all
PspMapping.destroy_all
RoutingRule.destroy_all

mock = Psp.create!(
  name: "MockPSP",
  psp_type: "rest",
  endpoints: {
    "authorize" => { "method" => "post", "url" => "http://localhost:3000/mock_psp/authorize", "headers" => {} }
  },
  auth: { "scheme" => "none" },
  credentials: {},
  active: true
)

PspMapping.create!(
  psp: mock,
  request_templates: {
    "authorize" => '{"amount": {{amount_cents}}, "currency": "{{currency}}", "card_token": "{{metadata.card_token}}"}'
  },
  response_templates: {
    "authorize" => '{"approved": {{ body.approved }}, "psp_reference": "{{ body.psp_reference }}", "status": {{ body.status }} }'
  }
)

RoutingRule.create!(
  name: "Small amounts to Mock",
  psp: mock,
  conditions: { "max_amount_cents" => 100000, "currencies" => ["USD", "EUR"] },
  active: true
)

puts "Seeded: #{Psp.count} psps, #{PspMapping.count} mappings, #{RoutingRule.count} rules"
