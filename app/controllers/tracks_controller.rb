class TracksController < ApplicationController
  def index
    return unless params[:track]
    @order = Order.find_by(ddtech_key: params[:track][:id])
    @movements = @order.movements.where(description: [
      Movement::DESCRIPTIONS[:new_order],
      Movement::DESCRIPTIONS[:supplied_order],
      Movement::DESCRIPTIONS[:assembled_order],
      Movement::DESCRIPTIONS[:sent_order]
    ])

    unless @order
      flash.now[:info] = "Order not found!"
    end
  end
end
