# frozen_string_literal: true

# Helper with functions for layout rendering
module LayoutHelper
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
    roles = roles.map { |key, value| [I18n.t("roles.#{key}"), value] }
    roles.sort { |a, b| a.first <=> b.first }
  end

  def parcels_for_select()
    Order::PARCELS.map{ |value| [value, value] }
  end

end
