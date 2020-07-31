# frozen_string_literal: true

# User definition class
class Order < ApplicationRecord
  include Searchable
  include Timeable

  PARCELS = %i[ESTAFETA FEDEX ZMG DHL].freeze
  STATUS = {
    new: 'new',
    supplied: 'supplied',
    assembled: 'assembled',
    packed: 'packed',
    sent: 'sent'
  }.freeze

  attr_accessor :updater_id

  before_validation :set_status, on: :create
  before_save :downcase_email

  before_save :create_movement

  belongs_to :user
  has_many :movements
  has_many :notes

  validates :client_email, :status, :parcel,
    presence: true,
    length: {maximum:50}

  validates :ddtech_key,
    presence: true,
    length: {minimum:5, maximum:6},
    uniqueness: {case_sensitive: true}

  validates :status, inclusion: {in: STATUS.values}, unless: :holding?

  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_status, -> (status) {
    where(status: status, holding: false) if status.present?
  }
  scope :urgent_first, -> { order(urgent: :desc) }

  def to_s
    "##{ddtech_key}"
  end

  def to_param
    "#{id}-#{ddtech_key}"
  end

  def hold
    self.update_attributes(holding: true)
  end

  def release
    self.update_attributes(holding: false)
  end

  def holding?
    self.holding
  end

  private

  def downcase_email
    self.client_email = client_email.downcase
  end

  def set_status
    self.status = STATUS[:new]
  end

  def create_movement(params = {})
    if self.status_changed? or self.guide_changed?
      params[:user_id] = self.updater_id ? self.updater_id : self.user_id
      params[:data] = self.guide if self.guide_changed?

      self.movements.build(params)
    end
  end
end
