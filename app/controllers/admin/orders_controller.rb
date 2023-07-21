# frozen_string_literal: true

module Admin
  # Admin Orders Controller
  class OrdersController < AdminController
    before_action :load_orders, only: :index
    before_action :set_order, only: :create

    skip_authorization_check only: [:update_guide, :update_status]
    load_and_authorize_resource except: [:arrears, :update_guide, :update_status]

    def index; end

    def arrears
      authorize! :read, Order

      since_param = filter_params(require: :since, default_value: '30')
      since_param = since_param.to_i.days.ago

      @arrears = Order.arrears.since(since_param).oldest.limit(50).includes(:user)
      @assemble_arrears = Order.assemble_arrears.since(since_param).oldest.limit(50).includes(:user)
    end

    def show
      @movements = @order.movements.includes(:user)
      @notes = @order.notes.recent.includes(:user)
    end

    def new; end

    def create
      @order.notes.build(message: params[:note][:message], user_id: current_user.id) if params[:note] and params[:note][:message].present?
      @order.order_tags.build(tag_id: params[:tag]) if params[:tag].present?

      if @order.save
        NotifyNewOrderJob.perform_async(@order)
        redirect_to new_admin_order_path(), flash: { success: t('.success', order: @order) }
      else
        render :new
      end
    end

    def edit; end

    def update
      if @order.update order_params
        redirect_to [:admin, @order], flash: { success: t('.success', order: @order) }
      else
        render :edit
      end
    end

    def update_guide
      return unless params[:order].present?
      @order = Order.find_by!(ddtech_key: params[:order][:ddtech_key])
      authorize! :update_guide, @order

      if current_user.role?(:provider_guides) # force guide update if current_user captures provider guides
        @order.force_status_update = true
        @order.multiple_packages = true # set multiple packages in case part of the order is sent by ddtech
        @order.notes.build(user_id: current_user.id, message: "Se capturó guía de proveedor: #{params[:order][:guide].join(' ')}")
      end

      status = 200
      if @order.update guide_params
        NotifyOrderTrackingIdJob.perform_async(@order, params[:order][:per_package_parcel])
      else
        if create_extra_movement(@order)
          NotifyOrderTrackingIdJob.perform_async(@order, params[:order][:per_package_parcel])
        else
          status = 400
        end
      end

      response = order_processing_response(@order, status)
      render status: status, json: response
    end

    def import_guides
      @errors = []
      (2..first_sheet.last_row).each do |row_num|
        next if first_sheet.row(row_num) == [nil, nil, nil]

        ddtech_key, tracking_num, carrier = first_sheet.row(row_num)
        @order = Order.find_by(ddtech_key: ddtech_key.to_s.strip)
        if @order.blank?
          @errors << "No se encontró el pedido: ##{ddtech_key}"
          next
        elsif tracking_num.blank? || !tracking_num.to_s.match?(/[0-9]{6}/)
          @errors << "Número de guía inválido para el pedido ##{ddtech_key} debe contener al menos 6 dígitos"
          next
        end

        if @order.update import_guides_params(tracking_num)
          NotifyOrderTrackingIdJob.perform_async(@order, carrier)
        else
          if create_extra_movement(@order)
            NotifyOrderTrackingIdJob.perform_async(@order, carrier)
          elsif @order.errors.any?
            @order.errors.full_messages.each do |msg|
              @errors << "##{@order.ddtech_key}: #{msg}"
            end
          end
        end
      end
      flash.now[:success] = t('.success') if @errors.empty?
      render :update_guide
    end

    def download_import_template
      file_path = Rails.root.join('public/carga-masiva-guias.xlsx')
      send_file(file_path, type: 'application/xlsx')
    end

    def update_status
      return unless params[:order].present?
      @order = Order.find_by!(ddtech_key: params[:order][:ddtech_key])
      authorize! :update_status, @order

      status = 200
      if @order.update status_params
        notify_status_change(@order)
      else
        unless create_extra_movement(@order)
          status = 400
        end
      end

      response = order_processing_response(@order, status)
      render status: status, json: response
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
      hash = params.require(:order).permit(:ddtech_key, :updater_id, :status, :data)
      hash[:updater_id] = current_user.id unless hash.keys.include? "updater_id"
      hash[:updating_status] = true
      return hash
    end

    def guide_params
      hash = Hash.new
      hash[:status] = Order::STATUS[:sent]
      guides = params[:order][:guide].reject { |el| el.empty? }
      hash[:guide] = guides.join(' y ')
      hash[:guide] += " -> #{params[:order][:data]}" if params[:order][:data].present?
      hash[:data] = hash[:guide]

      hash[:urgent] = false
      hash[:updater_id] = current_user.id
      return hash
    end

    def import_guides_params(tracking_num)
      hash = { status: Order::STATUS[:sent] }
      hash[:guide] = tracking_num
      hash[:data] = hash[:guide]
      hash[:urgent] = false
      hash[:updater_id] = current_user.id
      hash
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
          .urgent_first.recent.includes(:user, :tags)
      )
    end

    def set_order
      @order = current_user.orders.new(order_params)
    end

    def notify_status_change(order)
      # Only notify the client about the next statuses
      case order.status
      when Order::STATUS[:supplied]
        NotifyOrderSuppliedJob.perform_async(order)
      when Order::STATUS[:assembled]
        NotifyOrderAssembledJob.perform_async(order)
      end
    end

    def create_extra_movement(order)
      # verify the order has multiple packages option active
      if order.multiple_packages and !order.holding
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

        mvnt.data = order.data if order.data.present?
        mvnt.save
      else
        false
      end
    end

    def order_processing_response(order, status)
      response = {data: @order.as_json(include: {tags: {only: [:name, :css_class]}, notes: {only: :message}})}
      response[:data][:status_was] = t("order.statuses.#{@order.status_was}")
      response[:errors] = @order.errors.full_messages if status != 200 and @order.errors.any?
      return response
    end

    def first_sheet
      return @first_sheet if @first_sheet

      @roo_file = Roo::Spreadsheet.open(params[:import][:file])
      @first_sheet = @roo_file.sheet(0)
    end
  end
end
