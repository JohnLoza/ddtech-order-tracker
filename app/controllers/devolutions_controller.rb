class DevolutionsController < ApplicationController
  layout false

  def new
    @devolution = Devolution.new
  end

  def create
    @devolution = Devolution.new(devolution_params)
    if @devolution.save
      flash[:success] = 'Hola ya tenemos registrada tu solicitud, te entregamos tu rma: ' + @devolution.rma
      redirect_to new_devolution_path
    else
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
