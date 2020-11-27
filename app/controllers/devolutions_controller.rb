class DevolutionsController < ApplicationController
  layout false

  def new
    # @devolution = Devolution.first
    # @render :create and return
    @devolution = Devolution.new
  end

  def create
    @devolution = Devolution.new(devolution_params)
    unless @devolution.save
      render :new
    end
  end

  private
  def devolution_params
    params.require(:devolution).permit(
      :client_name,
      :email,
      :telephone,
      :client_type,
      :order_id,
      :products,
      :description,
      :devolution_address,
      :comments
    )
  end
end
