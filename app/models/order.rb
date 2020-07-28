# frozen_string_literal: true

# User definition class
class Order < ApplicationRecord
  include Searchable

  PARCELS = %i[ESTAFETA FEDEX ZMG DHL].freeze
  STATUS = {
    new: 'new',
    supplied: 'supplied',
    assembled: 'assembled',
    packed: 'packed',
    sent: 'sent'
  }.freeze

  attr_accessor :updater_id
  attr_accessor :needs_notification

  before_validation :set_status, on: :create
  before_save :downcase_email

  before_save :create_movement
  after_save :notify_client

  belongs_to :user
  has_many :movements

  validates :client_email, :status, :parcel,
    presence: true,
    length: {maximum:50}

  validates :ddtech_key,
    presence: true,
    length: {minimum:5, maximum:6},
    uniqueness: true

  validates :status, inclusion: {in: STATUS.values}

  scope :recent, -> { order(created_at: :desc) }

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

  def create_movement
    if self.status_changed? or self.guide_changed?
      params = {user_id: self.updater_id ? self.updater_id : self.user_id}
      params[:data] = self.guide if self.guide_changed?
      self.movements.build(params)
      self.needs_notification = true
    end
  end

  def notify_client
    if self.needs_notification
      ApplicationMailer.with(order: self)
        .notify_order_status_change.deliver_now
    end
  end
end
