class Admin::PspsController < ApplicationController
  before_action :set_psp, only: %i[ show edit update destroy test_connection ]

  def index
    @psps = Psp.all
  end

  def show; end

  def new
    @psp = Psp.new
  end

  def create
    @psp = Psp.new(psp_params)
    if @psp.save
      redirect_to admin_psp_path(@psp), notice: "PSP created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @psp.update(psp_params)
      redirect_to admin_psp_path(@psp), notice: "PSP updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @psp.destroy
    redirect_to admin_psps_path, notice: "PSP deleted"
  end

  def test_connection
    mapping = @psp.psp_mapping
    adapter = Adapters::DynamicRuntime.new(psp: @psp, mapping: mapping)
    result = adapter.call_operation(operation: "authorize", payload: { amount: 1, currency: "USD" })
    render json: { ok: true, result: result }
  rescue => e
    render json: { ok: false, error: e.message }, status: 422
  end

  private

  def set_psp
    @psp = Psp.find(params[:id])
  end

  def psp_params
    params.require(:psp).permit(:name, :psp_type, :active, endpoints: {}, auth: {}, credentials: {})
  end
end

