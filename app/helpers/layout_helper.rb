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
      raise ArgumentError, 'Parameter should be a string or an array'
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

  def status_badge(order)
    badge_class = order.status == Order::STATUS[:sent] ? 'success' : 'primary'

    if order.holding?
      content_tag(:span, t('labels.holding'),
        class: 'badge badge-danger badge-pill')
    else
      content_tag(:span, t("order.statuses.#{order.status}"),
        class: "badge badge-#{badge_class} badge-pill")
    end
  end

  def update_order_statuses_for_select(role)
    case role
    when User::ROLES[:admin]
      statuses = Order::STATUS.reject { |key, value|
        [Order::STATUS[:new], Order::STATUS[:sent]].include?(value)
      }
      statuses.map { |key, value| [t("order.status_change_msg.#{value}"), value] }
    when User::ROLES[:warehouse_boss]
      [
        [
          t("order.status_change_msg.#{Order::STATUS[:warehouse_entry]}"),
          Order::STATUS[:warehouse_entry]
        ],
        [
          t("order.status_change_msg.#{Order::STATUS[:supplied]}"),
          Order::STATUS[:supplied]
        ]
      ]
    when User::ROLES[:warehouse_exit]
      [
        [
          t("order.status_change_msg.#{Order::STATUS[:supplied]}"),
          Order::STATUS[:supplied]
        ]
      ]
    when User::ROLES[:assemble_boss]
      [
        [
          t("order.status_change_msg.#{Order::STATUS[:assemble_entry]}"),
          Order::STATUS[:assemble_entry]
        ],
        [
          t("order.status_change_msg.#{Order::STATUS[:assembled]}"),
          Order::STATUS[:assembled]
        ]
      ]
    when User::ROLES[:assemble_exit]
      [
        [
          t("order.status_change_msg.#{Order::STATUS[:assembled]}"),
          Order::STATUS[:assembled]
        ]
      ]
    when User::ROLES[:pack_boss]
      [
        [
          t("order.status_change_msg.#{Order::STATUS[:pack_entry]}"),
          Order::STATUS[:pack_entry]
        ],
        [
          t("order.status_change_msg.#{Order::STATUS[:packed]}"),
          Order::STATUS[:packed]
        ]
      ]
    when User::ROLES[:pack_exit]
      [
        [
          t("order.status_change_msg.#{Order::STATUS[:packed]}"),
          Order::STATUS[:packed]
        ]
      ]
    end
  end

  def movements_include?(movements, required)
    json = movements.as_json
    match = json.select {|s| s["description"] == required}
    match.any?
  end

end
