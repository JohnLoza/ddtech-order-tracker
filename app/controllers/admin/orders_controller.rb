# frozen_string_literal: true

module Admin
  # Admin Orders Controller
  class OrdersController < AdminController
    before_action :load_orders, only: :index
    before_action :set_new_order, only: :create

    skip_authorization_check only: [:update_guide, :update_status]
    load_and_authorize_resource except: [:arrears, :update_guide, :update_status]

    def index; end

    def arrears
      authorize! :read, Order
      @arrears = Order.arrears.oldest.limit(10).includes(:user)
      @assemble_arrears = Order.assemble_arrears.oldest.limit(10).includes(:user)
    end

    def show
      @movements = @order.movements.includes(:user)
      @notes = @order.notes.recent.includes(:user)
    end

    def new; end

    def create
      if @order.save
        NotifyStartOrderJob.perform_async(@order)
        redirect_to new_admin_order_path(), flash: { success: t('.success', order: @order) }
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
        if create_extra_movement(@order)
          render json: { data: @order.to_json }
          notify_status_change(@order)
        else
          render status: 400, json: { data: @order.errors.to_json }
        end
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
        if create_extra_movement(@order)
          render json: { data: @order.to_json }
        else
          render status: 400, json: { data: @order.errors.to_json }
        end
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
        :multiple_packages,
        :urgent
      )
    end

    def status_params
      hash = params.require(:order).permit(:ddtech_key, :updater_id, :status)
      hash[:updater_id] = current_user.id unless hash.keys.include? "updater_id"
      hash[:updating_status] = true
      return hash
    end

    def guide_params
      hash = Hash.new
      hash[:status] = Order::STATUS[:sent]
      guides = params[:order][:guide].reject { |el| el.empty? }
      hash[:guide] = guides.join(' y ')

      hash[:urgent] = false
      hash[:updater_id] = current_user.id
      return hash
    end

    def load_orders
      @pagy, @orders = pagy(
        Order.search(
            keywords: filter_params(require: :keywords),
            fields: [:ddtech_key, :client_email]
          ).by_user(filter_params(require: :user_id))
          .by_status(filter_params(require: :status))
          .by_parcel(filter_params(require: :parcel))
          .by_date(filter_params(require: :date))
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

    def create_extra_movement(order)
      json_e = order.errors.as_json
      # verify the order has multiple packages option active
      if order.multiple_packages and json_e.has_key? :status and json_e[:status].include? 'not_next_step'

        if [Order::STATUS[:assemble_entry], Order::STATUS[:assembled]].include? order.status and
            !order.assemble # do not let to save assemble statuses if it doesnt even has to be assembled
          return false
        end

        # Create only a new movement record while not updating the status
        mvnt = Movement.new({
          order_id: order.id,
          user_id: order.updater_id ? order.updater_id : current_user.id,
          description: "#{order.status}_order"
        })

        mvnt.data = order.guide if order.guide.present?
        mvnt.save!
      else
        false
      end
    end

  end
end
