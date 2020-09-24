# frozen_string_literal: true

# User definition class
class Order < ApplicationRecord
  include Searchable
  include Timeable

  PARCELS = %i[ESTAFETA FEDEX ZMG DHL].freeze
  # STATUSES have to be in secuence
  STATUS = {
    new: 'new',
    warehouse_entry: 'warehouse_entry',
    supplied: 'supplied',
    assemble_entry: 'assemble_entry',
    assembled: 'assembled',
    packed: 'packed',
    sent: 'sent'
  }.freeze

  attr_accessor :updater_id
  attr_accessor :updating_status

  before_validation :set_status, on: :create
  before_validation :trim_ddtech_key
  before_save :downcase_email
  before_save :create_movement

  belongs_to :user
  has_many :movements
  has_many :notes

  validates :client_email, :status, :parcel,
    presence: true,
    length: { maximum: 50 }

  validates :ddtech_key,
    presence: true,
    length: { minimum: 5, maximum: 6 },
    uniqueness: { case_sensitive: true }

  validates :guide, length: { maximum: 250 }

  validates :status, inclusion: { in: STATUS.values }
  validate :status_change, on: :update

  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_status, -> (status) {
    where(status: status, holding: false) if status.present?
  }
  scope :urgent_first, -> { order(urgent: :desc) }
  scope :arrears, -> () { where.not(status: STATUS[:sent]).where(assemble: false, holding: false) }
  scope :assemble_arrears, -> () { where.not(status: STATUS[:sent]).where(assemble: true) }

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

  def trim_ddtech_key
    self.ddtech_key.strip!
  end

  def set_status
    self.status = STATUS[:new] unless self.status.present?
  end

  def create_movement(params = {})
    if self.status_changed? or self.guide_changed?
      params[:user_id] = self.updater_id ? self.updater_id : self.user_id
      params[:data] = self.guide if self.guide_changed?

      self.movements.build(params)
    end
  end

  def status_change
    if !self.status_changed?
      self.errors.add(:status, 'not_next_step') if self.updating_status
      return
    end

    old_status, new_status = self.changes['status']
    new_status_is_ok = true

    if old_status != STATUS[:supplied]
      status_keys = Order::STATUS.keys # statuses are in secuence
      indx = status_keys.index(old_status.to_sym)
      new_status_is_ok = false unless new_status == STATUS[status_keys[indx + 1]]
    else
      if self.assemble
        new_status_is_ok = false unless new_status == STATUS[:assemble_entry]
      else
        new_status_is_ok = false unless new_status == STATUS[:packed]
      end
    end

    unless new_status_is_ok
      self.errors.add(:status, 'not_next_step')
    end
  end
end
