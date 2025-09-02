class PaymentsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    payment = Payment.create!(amount_cents: params[:amount_cents], currency: params[:currency], metadata: params[:metadata] || {})
    event = Orchestration::Processor.new.authorize(payment: payment)
    render json: { payment_id: payment.id, event: event.to_h }
  rescue => e
    render json: { error: e.message }, status: 422
  end
end

