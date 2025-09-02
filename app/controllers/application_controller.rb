class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :coerce_json_fields

  private

  def coerce_json_fields
    %w[endpoints auth credentials request_templates response_templates].each do |key|
      next unless params[key].is_a?(String)
      begin
        params[key] = JSON.parse(params[key])
      rescue JSON::ParserError
      end
    end
  end
end
