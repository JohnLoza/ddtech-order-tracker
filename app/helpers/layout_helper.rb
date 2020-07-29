# frozen_string_literal: true

# Helper with functions for layout rendering
module LayoutHelper
  include Pagy::Frontend

  def active_class_for(required)
    case required.class.to_s
    when 'String'
      params[:controller] == required ? 'active' : ''
    when 'Array'
      required.include?(params[:controller]) ? 'active' : ''
    else
      raise 'Parameter should be a string or an array'
    end
  end

  def roles_without(role)
    if role.is_a?(Array)
      User::ROLES.reject { |key, _value| role.include?(key) }
    elsif role.is_a?(Symbol)
      User::ROLES.reject { |key, _value| key == role }
    else
      raise ArgumentError, 'Parameter should be a Symbol or an Array'
    end
  end

  def roles_for_select()
    roles = roles_without(:admin)
    roles = roles.map { |key, value| [I18n.t("user.roles.#{key}"), value] }
    roles.sort { |a, b| a.first <=> b.first }
  end

  def users_for_select(args = {})
    User.by_role(args[:role])
      .map{ |user| [user, user.id] }
  end

  def order_statuses_for_select()
    Order::STATUS.map { |key, value| [I18n.t("order.statuses.#{key}"), value] }
  end

  def parcels_for_select()
    Order::PARCELS.map { |value| [value, value] }
  end

  def next_status_for_order(order)
    case order.status
    when Order::STATUS[:new]
      Order::STATUS[:supplied]
    when Order::STATUS[:supplied]
      order.assemble ? Order::STATUS[:assembled] : Order::STATUS[:packed]
    when Order::STATUS[:assembled]
      Order::STATUS[:packed]
    end
  end

  def next_status_message(order)
    t("order.status_change_msg.#{next_status_for_order(order)}")
  end

end
