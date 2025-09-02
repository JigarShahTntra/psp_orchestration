class RoutingRule < ApplicationRecord
  belongs_to :psp
  store_accessor :conditions

  def matches?(amount_cents:, currency:)
    return false unless active
    min = (conditions || {}).fetch("min_amount_cents", -Float::INFINITY)
    max = (conditions || {}).fetch("max_amount_cents", Float::INFINITY)
    allowed_currencies = (conditions || {}).fetch("currencies", [])
    within_amount = amount_cents.to_i >= min.to_i && amount_cents.to_i <= max.to_i
    currency_ok = allowed_currencies.empty? || allowed_currencies.include?(currency)
    within_amount && currency_ok
  end
end
