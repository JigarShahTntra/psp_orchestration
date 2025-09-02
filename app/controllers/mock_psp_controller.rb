class MockPspController < ApplicationController
  protect_from_forgery with: :null_session

  def authorize
    amount = params[:amount] || params[:amount_cents]
    approved = amount.to_i < 5000
    render json: { approved: approved, psp_reference: SecureRandom.hex(8), status: approved ? 200 : 402 }
  end
end

