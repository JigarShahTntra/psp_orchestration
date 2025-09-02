require "rdkafka"

module KafkaInfra
  class Consumer
    def initialize(group_id: "psp_orchestrator")
      @consumer ||= Rdkafka::Config.new(kafka_config(group_id)).consumer
    end

    def subscribe(topic)
      @consumer.subscribe(topic)
    end

    def each_message
      loop do
        msg = @consumer.poll(1000)
        next unless msg
        yield msg
      end
    end

    private

    def kafka_config(group_id)
      {
        "bootstrap.servers" => ENV.fetch("KAFKA_BROKERS", "localhost:9092"),
        "group.id" => group_id,
        "auto.offset.reset" => "earliest"
      }
    end
  end
end

