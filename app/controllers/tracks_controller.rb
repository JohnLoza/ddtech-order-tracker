class TracksController < ApplicationController
  layout false

  def index
    return unless params[:track]
    @order = Order.find_by(ddtech_key: params[:track][:id])
    unless @order
      flash.now[:info] = "No se encontró el pedido con clave: ##{params[:track][:id]}"
      return
    end

    @movements = @order.movements.where(description: [
      Movement::DESCRIPTIONS[:new_order],
      Movement::DESCRIPTIONS[:supplied_order],
      Movement::DESCRIPTIONS[:assembled_order],
      Movement::DESCRIPTIONS[:sent_order]
    ])
  end
end
