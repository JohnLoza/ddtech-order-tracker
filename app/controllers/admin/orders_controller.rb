# frozen_string_literal: true

module Admin
  # Admin Orders Controller
  class OrdersController < AdminController
    before_action :load_orders, only: :index
    before_action :set_new_order, only: :create
    load_and_authorize_resource

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
        redirect_to [:admin, @order], flash: { success: t('.success', order: @order) }
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
        :parcel
      )
    end

    def load_orders
      @orders = Order.all.includes(:user)
    end

    def set_new_order
      @order = current_user.orders.new(order_params)
    end
  end
end
