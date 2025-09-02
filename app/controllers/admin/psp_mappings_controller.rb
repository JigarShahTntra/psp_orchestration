class Admin::PspMappingsController < ApplicationController
  before_action :set_mapping, only: %i[ show edit update destroy ]

  def index
    @psp_mappings = PspMapping.includes(:psp).all
  end

  def show; end

  def new
    @psp_mapping = PspMapping.new
  end

  def create
    @psp_mapping = PspMapping.new(mapping_params)
    if @psp_mapping.save
      redirect_to admin_psp_mapping_path(@psp_mapping), notice: "Mapping created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @psp_mapping.update(mapping_params)
      redirect_to admin_psp_mapping_path(@psp_mapping), notice: "Mapping updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @psp_mapping.destroy
    redirect_to admin_psp_mappings_path, notice: "Mapping deleted"
  end

  private

  def set_mapping
    @psp_mapping = PspMapping.find(params[:id])
  end

  def mapping_params
    params.require(:psp_mapping).permit(:psp_id, request_templates: {}, response_templates: {})
  end
end

