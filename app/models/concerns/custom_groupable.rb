# frozen_string_literal: true

require 'active_support/concern'

# For this concern to work, the model should have an user_id attribute
# and timestamps
module CustomGroupable
  extend ActiveSupport::Concern

  included do
    scope :custom_group, -> (grouping) {
      return all unless grouping.present?
      raise ArgumentError.new('unkown grouping: ' + grouping) if !%w[user_id day week month year].include? grouping

      case grouping
      when 'user_id'
        group(:user_id)
      when 'day'
        group('DATE_FORMAT(created_at, "%d-%m-%Y")')
      when 'week'
        group('CONCAT(WEEK(created_at), " / ", YEAR(created_at))')
      when 'month'
        group('DATE_FORMAT(created_at, "%m-%Y")')
      when 'year'
        group('YEAR(created_at)')
      end
    }
  end

  class_methods do
    # class methods go here #
  end
end
