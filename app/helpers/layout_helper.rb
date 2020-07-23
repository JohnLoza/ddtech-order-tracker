# frozen_string_literal: true

# Helper with functions for layout rendering
module LayoutHelper
  def activeClassFor(required)
    case required.class.to_s
    when 'String'
      params[:controller] == required ? 'active' : ''
    when 'Array'
      required.include?(params[:controller]) ? 'active' : ''
    else
      raise 'Parameter should be a string or an array'
    end
  end
end
