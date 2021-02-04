# frozen_string_literal: true

module Admin
  # Admin Tags Controller
  class ShipmentsController < AdminController
    before_action :load_shipments, only: :index
    load_and_authorize_resource

    def index; end

    def show; end

    def new; end

    def create
      saved = false
      Shipment.transaction do
        if @shipment.save
          params[:shipment_product].values.each do |sp|
            raise ActiveRecord::Rollback unless sp['destinations'].present?
            @sp = ShipmentProduct.create!(shipment_id: @shipment.id, ddtech_id: sp['ddtech_id'])
            ShipmentProductDestination.insert_all(
              sp['destinations'].values.map{ |dest|
                {
                  shipment_product_id: @sp.id,
                  units: dest['units'],
                  destination: dest['destination'],
                  created_at: Time.now,
                  updated_at: Time.now
                }
              }
            )
          end
          saved = true
        else
          raise ActiveRecord::Rollback
        end
      end

      if saved
        flash[:success] = t('.success')
        redirect_to admin_shipment_path @shipment
      else
        render :new
      end
    end

    def edit; end

    def update
      if @shipment.update shipment_params
        flash[:success] = t('.success')
        redirect_to admin_shipment_path @shipment
      else
        render :edit
      end
    end

    def destroy
      if @shipment.destroy
        flash[:success] = t('.success')
      else
        flash[:info] = t('.failure')
      end
      redirect_to admin_shipments_path
    end

    private

    def shipment_params
      params.require(:shipment).permit(
        :supplier_id,
        :origin_state_id,
        :estimated_arrival,
        :comments,
        :status
      )
    end

    def load_shipments
      start_date = filter_params(require: :start_date)
      end_date = filter_params(require: :end_date)

      @pagy, @shipments = pagy(
        Shipment.all.search(
            keywords: filter_params(require: :keywords),
            joins: :shipment_products,
            fields: ['shipments.hash_id', 'shipments.comments', 'shipment_products.ddtech_id']
          )
          .by_supplier(filter_params(require: :supplier))
          .by_status(filter_params(require: :status))
          .between_dates(start_date, end_date)
          .recent.includes(:supplier, :origin_state)
      )
    end
  end
end

