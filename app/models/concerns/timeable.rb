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
  end

  class_methods do
    # class methods go here #
  end
end
