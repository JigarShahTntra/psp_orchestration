module Orchestration
  class Router
    def initialize(rules: RoutingRule.all)
      @rules = rules
    end

    def select_psp_for(amount_cents:, currency:)
      rule = @rules.find { |r| r.matches?(amount_cents: amount_cents, currency: currency) }
      rule&.psp
    end
  end
end

