# frozen_string_literal: true

module Admin
  # Admin Dashboard Controller
  class DashboardController < AdminController
    skip_authorization_check

    def index
      @start_date = filter_params(require: :start_date, default_value: Date.today)
      @end_date = filter_params(require: :end_date, default_value: Date.today)

      @pendant_orders = Order.where.not(status: Order::STATUS[:sent]).where(holding: false).group(:status).count
      @pendant_orders.keys.each { |key| @pendant_orders[t("order.statuses.#{key}")] = @pendant_orders.delete(key) }

      @orders_by_parcel = Order.beetween_dates(@start_date, @end_date).group(:parcel).count

      @orders_by_user = Order.beetween_dates(@start_date, @end_date).group(:user_id).count.as_json
      @orders_by_user = replace_id_by_username @orders_by_user

      @supplied_orders = Movement.beetween_dates(@start_date, @end_date).where(description: Movement::DESCRIPTIONS[:warehouse_entry_order]).group(:user_id).count.as_json
      @supplied_orders = replace_id_by_username @supplied_orders

      @assembled_orders = Movement.beetween_dates(@start_date, @end_date).where(description: Movement::DESCRIPTIONS[:assemble_entry_order]).group(:user_id).count.as_json
      @assembled_orders = replace_id_by_username @assembled_orders

      @packed_orders = Movement.beetween_dates(@start_date, @end_date).where(description: Movement::DESCRIPTIONS[:packed_order]).group(:user_id).count.as_json
      @packed_orders = replace_id_by_username @packed_orders

      @guides_registered = Movement.beetween_dates(@start_date, @end_date).where(description: Movement::DESCRIPTIONS[:sent_order]).group(:user_id).count.as_json
      @guides_registered = replace_id_by_username @guides_registered
    end

    private
    def replace_id_by_username(orders)
      merged_hash = {}
      users = User.select(:id, :name).where(id: orders.keys)
      users.each do |user|
        merged_hash[user.name] = orders["#{user.id}"]
      end

      return merged_hash
    end
  end
end
