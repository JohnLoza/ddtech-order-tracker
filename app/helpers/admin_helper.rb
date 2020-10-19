# frozen_string_literal: true

# Helper for use in Admin Controllers
module AdminHelper
  def filter_params(opts = {})
    filter = params[:filter] || {}

    if opts[:require]
      if opts[:default_value]
        filter[opts[:require]].blank? ? opts[:default_value] : filter[opts[:require]]
      else
        filter[opts[:require]]
      end
    else
      filter
    end
  end
end
