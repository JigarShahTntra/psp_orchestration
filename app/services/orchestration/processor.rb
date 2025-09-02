module Orchestration
  class Processor
    def initialize(router: Router.new, producer: KafkaInfra::Producer.new)
      @router = router
      @producer = producer
    end

    def authorize(payment:)
      psp = @router.select_psp_for(amount_cents: payment.amount_cents, currency: payment.currency)
      raise "No PSP available for payment" unless psp

      adapter = build_adapter(psp)
      result = adapter.call_operation(operation: "authorize", payload: payment.attributes)

      if success?(result)
        event = Payments::Events::PaymentAuthorized.new(payment_id: payment.id, data: result)
      else
        event = Payments::Events::PaymentDeclined.new(payment_id: payment.id, data: result)
      end

      @producer.publish(topic: event.topic, key: payment.id.to_s, payload: event.to_h)
      event
    end

    private

    def build_adapter(psp)
      mapping = psp.psp_mapping
      Adapters::DynamicRuntime.new(psp: psp, mapping: mapping)
    end

    def success?(result)
      result.is_a?(Hash) && result["status"].to_s.start_with?("2") || result["approved"] == true
    end
  end
end

