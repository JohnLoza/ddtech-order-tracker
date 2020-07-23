# frozen_string_literal: true

# User definition class
class Order < ApplicationRecord
  include Searchable

  PARCELS = %i[ESTAFETA FEDEX ZMG DHL].freeze
  STATUS = {
    new: 'new'
  }.freeze

  before_validation :set_status
  before_save :downcase_email

  belongs_to :user

  validates :client_email, :status, :parcel,
    presence: true,
    length: {minimum:3, maximum:50}

  validates :ddtech_key,
    presence: true,
    length: {minimum:5, maximum:6},
    uniqueness: true

  validates :status, inclusion: {in: STATUS.values}

  def to_s
    "##{ddtech_key}"
  end

  def to_param
    "#{id}-#{ddtech_key}"
  end

  private

  def downcase_email
    self.client_email = client_email.downcase
  end

  def set_status
    self.status = STATUS[:new]
  end
end
