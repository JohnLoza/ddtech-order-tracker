# frozen_string_literal: true

module Admin
  # Admin OrderTags Controller
  class OrderTagsController < AdminController
    load_and_authorize_resource only: :create

    def create
      msg = @order_tag.save ? 'Etiqueta guardada' : 'Ocurrió un error al guardar la etiqueta'
      redirect_to admin_order_path(@order_tag.order_id), flash: {success: msg}
    end

    def destroy
      @order_tag = OrderTag.find_by!(order_id: params[:order_id], tag_id: params[:id])
      authorize! :destroy, @order_tag
      @order_tag.destroy
      render json: { data: @order_tag.as_json }
    end

    private

    def order_tag_params
      params.require(:order_tag).permit(:order_id, :tag_id)
    end
  end
end


