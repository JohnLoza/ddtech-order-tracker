# frozen_string_literal: true

require 'active_support/concern'

# For this concern to work, generate a migration for the model adding
# a datetime 'deleted_at' attribute with nil as default
module Timeable
  extend ActiveSupport::Concern

  included do
    scope :recent, -> { order(created_at: :desc) }
    scope :oldest, -> { order(created_at: :asc) }

    scope :recent_update, -> { order(updated_at: :desc) }
    scope :oldest_update, -> { order(updated_at: :asc) }

    scope :since, -> (date_time) { beetween_dates(date_time, Time.now) }
    scope :since_update, -> (date_time) { between_dates(date_time, Time.now, 'updated_at') }

    scope :today, -> { where(created_at: Date.today.all_day) }
    scope :updated_today, -> { where(updated_at: Date.today.all_day) }

    scope :by_date, -> (date) {
      where(created_at: Date.parse(date).all_day) if date.present?
    }
    scope :by_updated_date, -> (date) {
      where(updated_at: Ate.parse(date).all_day) if date.present?
    }

    scope :beetween_dates, -> (start_date, end_date, field = 'created_at') {
      return all unless start_date.present? and end_date.present?
      start_date = start_date.to_date
      end_date = end_date.to_date
      where(field => start_date.beginning_of_day..end_date.end_of_day)
    }
  end

  class_methods do
    # class methods go here #
  end
end
