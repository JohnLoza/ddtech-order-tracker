# frozen_string_literal: true

# Devolution definition class
class Devolution < ApplicationRecord
  include Searchable
  include Timeable

  before_validation :set_rma, on: :create

  before_save { self.rma = rma.upcase }
  before_save { self.email = email.downcase }
  before_save { self.free_guide = self.free_guide_electible? }

  before_update :notify_package_received
  before_update :send_guide_id

  after_create { NotifyRmaJob.perform_async(self) }

  belongs_to :user, optional: true

  validates :rma, presence: true, uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  validates :client_name, :telephone, :client_type, :order_id, :products, :description,
    :street, :colony, :zc, :city, :state, presence: true
  validates :client_name, :street, :colony, :city, :state, length: { maximum: 60 }
  validates :zc, length: { is: 5 }

  validates :email, length: { maximum: 50 }
  validates :telephone, length: { maximum: 15 }
  validates :order_id, length: { minimum: 5, maximum: 6 }
  validates :products, :description, length: { maximum: 250 }

  validates :comments, :actions_taken, :parcel, :guide_id, length: { maximum: 250 }
  validate :timeframe_between_devolutions, on: :create

  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :taken, -> (opt) {
    return all unless opt.present?
    if opt == 'not_taken'
      where(user_id: nil)
    else
      where.not(user_id: nil)
    end
  }
  scope :by_parcel, -> (parcel) { where(parcel: parcel) if parcel.present? }

  def to_s
    "##{rma}"
  end

  def address
    "
      #{self.street}
      #{self.colony}
      #{self.zc}
      #{self.city}, #{self.state}
    "
  end

  def last_order_guide
    last_guide = Movement.joins(:order)
                   .where(orders: { ddtech_key: self.order_id })
                   .where(description: Movement::DESCRIPTIONS[:sent_order])
                   .order(created_at: :desc).last
    return last_guide ? {guide: last_guide.data, date: last_guide.created_at} : nil
  end

  def free_guide_electible?
    guide = last_order_guide
    return false unless guide.present?

    return guide[:date] > 40.days.ago ? true : false
  end

  private
  def set_rma
    self.rma = Utils.new_alphanumeric_token(5)
  end

  def send_guide_id
    if self.guide_id_changed? or self.parcel_changed?
      NotifyDevolutionTrackingIdJob.perform_async(self)
    end
  end

  def notify_package_received
    if self.user_id_changed?
      NotifyDevolutionPackageReceivedJob.perform_async(self)
    end
  end

  def timeframe_between_devolutions
    another_dev = Devolution.where(email: self.email)
                    .or(Devolution.where(order_id: self.order_id)).last
    return unless another_dev.present?

    # if the other devolution is less than 1 week old
    if another_dev.created_at.to_date > 1.week.ago.to_date
      self.errors.add(:created_at, :limit_reached)
    end
  end
end
