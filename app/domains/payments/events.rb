module Payments
  module Events
    class Base
      attr_reader :payment_id, :data

      def initialize(payment_id:, data: {})
        @payment_id = payment_id
        @data = data
      end

      def topic
        "payments"
      end

      def type
        self.class.name.split("::").last
      end

      def to_h
        { type: type, payment_id: payment_id, data: data }
      end
    end

    class PaymentAuthorized < Base; end
    class PaymentDeclined < Base; end
    class PaymentCaptured < Base; end
    class PaymentSettled < Base; end
  end
end

