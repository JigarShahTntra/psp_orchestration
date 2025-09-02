module KafkaInfra
  class PaymentsConsumerRunner
    def initialize(topic: "payments")
      @topic = topic
      @consumer = KafkaInfra::Consumer.new(group_id: "payments-updater")
    end

    def start
      @consumer.subscribe(@topic)
      @consumer.each_message do |msg|
        handle_message(JSON.parse(msg.payload))
      end
    end

    private

    def handle_message(event)
      payment = Payment.find_by(id: event["payment_id"]) or return
      case event["type"]
      when "PaymentAuthorized"
        payment.update!(status: :authorized, external_id: event.dig("data", "psp_reference"))
      when "PaymentDeclined"
        payment.update!(status: :declined)
      when "PaymentCaptured"
        payment.update!(status: :captured)
      when "PaymentSettled"
        payment.update!(status: :settled)
      end
    end
  end
end