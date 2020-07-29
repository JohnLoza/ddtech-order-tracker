# frozen_string_literal: true

module Admin
  # Admin Orders Controller
  class OrdersController < AdminController
    before_action :load_orders, only: :index
    before_action :load_and_authorize_order, only: :update
    before_action :set_new_order, only: :create

    load_and_authorize_resource except: [:update]

    def index; end

    def show
      @movements = @order.movements.includes(:user)
      @notes = @order.notes.recent.includes(:user)
    end

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

    def hold
      @order.movements.build(
        user_id: current_user.id, data: params[:movement][:data],
        description: Movement::DESCRIPTIONS[:holded_order])
      if @order.hold
        flash[:success] = t('.success', order: @order)
      else
        @order.errors.full_messages.each { |error| logger.debug "/// error: #{error}" }
        flash[:info] = t('failure', order: @order)
      end
      redirect_to admin_order_path @order
    end

    def release
      @order.movements.build(
        user_id: current_user.id, data: params[:movement][:data],
        description: Movement::DESCRIPTIONS[:released_order])
      if @order.release
        flash[:success] = t('.success', order: @order)
      else
        flash[:info] = t('failure', order: @order)
      end
      redirect_to admin_order_path @order
    end

    private

    def order_params
      params.require(:order).permit(
        :ddtech_key,
        :client_email,
        :parcel,
        :guide,
        :status,
        :assemble
      )
    end

    def load_orders
      @pagy, @orders = pagy(
        Order.search(
            keywords: filter_params(require: :ddtech_key),
            fields: [:ddtech_key]
          ).by_user(filter_params(require: :user_id))
          .by_status(filter_params(require: :status))
          .recent.includes(:user)
      )
    end

    def set_new_order
      @order = current_user.orders.new(order_params)
    end

    def load_and_authorize_order
      @order = Order.find(params[:id])
      @order.updater_id = current_user.id
      if params[:order][:guide]
        authorize! :update_guide, @order
      elsif params[:order][:status]
        authorize! :update_status, @order
      else
        authorize! :update, @order
      end
    end

  end
end
