class DevolutionsController < ApplicationController
  layout false

  def show
    require "barby"
    require "barby/barcode/code_128"
    require "barby/outputter/png_outputter"

    @devolution = Devolution.find(params[:id])
    @barcode = Barby::Code128.new(@devolution.rma).to_image.to_data_url

    respond_to do |format|
      format.any { render_404 }
      format.html { render 'show.pdf.erb' }
      format.pdf { render pdf: "ddtech_devolution_#{@devolution.rma}" }
    end
  end

  def new
    #@devolution = Devolution.first
    #render :create and return
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
