# frozen_string_literal: true

require 'active_support/concern'

# For this concern to work, generate a migration for the model adding
# a datetime 'deleted_at' attribute with nil as default
module SoftDeletable
  extend ActiveSupport::Concern

  included do
    attr_accessor :force_destroy

    scope :active,   -> { where(deleted_at: nil) }
    scope :inactive, -> { where.not(deleted_at: nil) }
  end

  def active?
    !deleted_at.present?
  end

  def inactive?
    deleted_at.present?
  end

  def destroy
    if self.force_destroy
      super
    else
      update(deleted_at: Time.now)
    end
  end

  def restore!
    update(deleted_at: nil)
  end

  def really_destroy
    self.force_destroy = true
    destroy
  end

  class_methods do
    # class methods go here #
  end
end
