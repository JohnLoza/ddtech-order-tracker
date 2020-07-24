# frozen_string_literal: true

module Admin
  # Admin Orders Controller
  class OrdersController < AdminController
    before_action :load_orders, only: :index
    before_action :load_and_authorize_order, only: :update
    before_action :set_new_order, only: :create

    load_and_authorize_resource except: :update

    def index; end

    def show; end

    def new; end

    def create
      if @order.save
        redirect_to [:admin, @order], flash: { success: t('.success', order: @order) }
      else
        render :new
      end
    end

    def edit; end

    def update
      if @order.update_attributes order_params
        url = params[:redirect_url].present? ? params[:redirect_url] : [:admin, @order]
        redirect_to url, flash: { success: t('.success', order: @order) }
      else
        render :edit
      end
    end

    def destroy
      if @order.destroy
        flash[:success] = t('.success', order: @order)
      else
        flash[:info] = t('.failure', order: @order)
      end
      redirect_to admin_orders_path
    end

    private

    def order_params
      params.require(:order).permit(
        :ddtech_key,
        :client_email,
        :parcel,
        :assemble,
        :status
      )
    end

    def load_orders
      @orders = Order.all.includes(:user)
    end

    def set_new_order
      @order = current_user.orders.new(order_params)
    end

    def load_and_authorize_order
      @order = Order.find(params[:id])
      if params[:order][:status]
        authorize! :update_status, @order
      else
        authorize! :update, @order
      end
    end

  end
end
