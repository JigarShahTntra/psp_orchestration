require "json"
require "faraday"
require "jsonpath"
require "liquid"

module Adapters
  class DynamicRuntime < Base
    def call_operation(operation:, payload: {})
      endpoint = @psp.endpoints[operation]
      raise ArgumentError, "missing endpoint for #{operation}" unless endpoint

      http_method = (endpoint["method"] || "post").downcase
      url = endpoint["url"]
      headers = build_headers(endpoint)
      body = build_body(operation: operation, payload: payload)

      response = Faraday.public_send(http_method, url) do |req|
        req.headers = headers
        if %w[post put patch].include?(http_method)
          req.body = body.to_json
          req.headers["Content-Type"] ||= "application/json"
        end
      end

      normalize_response(operation: operation, raw_body: response.body, status: response.status)
    end

    private

    def build_headers(endpoint)
      base = endpoint["headers"] || {}
      auth = @psp.auth || {}
      case auth["scheme"]
      when "api_key"
        base[auth["header" ]|| "Authorization"] = format(auth["format"] || "Bearer {{api_key}}", "api_key" => credential("api_key"))
      when "basic"
        token = Base64.strict_encode64("#{credential("username")}:#{credential("password")}")
        base["Authorization"] = "Basic #{token}"
      end
      base
    end

    def format(template, assigns)
      Liquid::Template.parse(template).render(assigns)
    end

    def credential(key)
      (@psp.credentials || {})[key]
    end

    def build_body(operation:, payload: {})
      mapping = @mapping&.request_templates&.dig(operation)
      return payload unless mapping

      Liquid::Template.parse(mapping).render(payload.transform_keys(&:to_s))
      JSON.parse(Liquid::Template.parse(mapping).render(payload.transform_keys(&:to_s)))
    end

    def normalize_response(operation:, raw_body:, status:)
      template = @mapping&.response_templates&.dig(operation)
      body = parse_json_safe(raw_body)
      return { status: status, raw: body } unless template

      assigns = { "body" => body }
      rendered = Liquid::Template.parse(template).render(assigns)
      JSON.parse(rendered)
    end

    def parse_json_safe(string)
      JSON.parse(string)
    rescue JSON::ParserError
      { "raw" => string }
    end
  end
end

