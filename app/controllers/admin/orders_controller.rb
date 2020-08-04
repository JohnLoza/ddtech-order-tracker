# frozen_string_literal: true

module Admin
  # Admin Orders Controller
  class OrdersController < AdminController
    before_action :load_orders, only: :index
    before_action :set_new_order, only: :create

    skip_authorization_check only: [:update_guide, :update_status]
    load_and_authorize_resource except: [:update_guide, :update_status]

    def index; end

    def show
      @movements = @order.movements.includes(:user)
      @notes = @order.notes.recent.includes(:user)
    end

    def new; end

    def create
      if @order.save
        NotifyStartOrderJob.perform_async(@order)
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

    def update_guide
      return unless params[:order].present?
      @order = Order.find_by!(ddtech_key: params[:order][:ddtech_key])
      authorize! :update_guide, @order

      if @order.update_attributes guide_params
        notify_status_change(@order)
        render json: { data: @order.to_json }
      else
        render status: 400, json: { data: @order.errors.to_json }
      end
    end

    def update_status
      return unless params[:order].present?
      @order = Order.find_by!(ddtech_key: params[:order][:ddtech_key])
      authorize! :update_status, @order

      if @order.update_attributes status_params
        notify_status_change(@order)
        render json: { data: @order.to_json }
      else
        render status: 400, json: { data: @order.errors.to_json }
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
        :assemble,
        :urgent
      )
    end

    def status_params
      hash = params.require(:order).permit(:ddtech_key, :updater_id, :status)
      hash[:updater_id] = current_user.id unless hash.keys.include? "updater_id"
      return hash
    end

    def guide_params
      hash = Hash.new
      hash[:status] = Order::STATUS[:sent]
      hash[:guide] = params[:order][:guide].join(' y ')

      hash[:urgent] = false
      hash[:updater_id] = current_user.id
      return hash
    end

    def load_orders
      @pagy, @orders = pagy(
        Order.search(
            keywords: filter_params(require: :ddtech_key),
            fields: [:ddtech_key]
          ).by_user(filter_params(require: :user_id))
          .by_status(filter_params(require: :status))
          .urgent_first.recent.includes(:user)
      )
    end

    def set_new_order
      @order = current_user.orders.new(order_params)
    end

    def notify_status_change(order)
      # Only notify the client about the next statuses
      case order.status
      when Order::STATUS[:supplied]
        NotifySuppliedOrderJob.perform_async(order)
      when Order::STATUS[:assembled]
        NotifyAssembledOrderJob.perform_async(order)
      when Order::STATUS[:sent]
        NotifySentOrderJob.perform_async(order)
      end
    end

  end
end
