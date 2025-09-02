require "rdkafka"

module KafkaInfra
  class Producer
    def initialize
      @producer ||= Rdkafka::Config.new(kafka_config).producer
    end

    def publish(topic:, key:, payload:)
      @producer.produce(topic: topic, key: key, payload: payload.to_json).wait
    end

    private

    def kafka_config
      {
        "bootstrap.servers" => ENV.fetch("KAFKA_BROKERS", "localhost:9092"),
        "message.send.max.retries" => 3
      }
    end
  end
end

