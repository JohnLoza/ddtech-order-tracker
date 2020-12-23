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
  before_update :notificate_resolution

  after_create { NotifyRmaJob.perform_async(self) }

  belongs_to :user, optional: true

  validates :rma, presence: true, uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 50 },
    format: { with: VALID_EMAIL_REGEX }

  validates :client_name, presence: true, length: { maximum: 60 }

  validates :street, presence: true, length: { maximum: 60 }
  validates :colony, presence: true, length: { maximum: 40 }
  validates :zc, length: { is: 5 }
  validates :city, presence: true, length: { maximum: 25 }
  validates :state, presence: true, length: { maximum: 15 }

  validates :telephone, presence: true, length: { maximum: 15 }
  validates :order_id, presence: true, length: { minimum: 5, maximum: 6 }

  validates :voucher_folio, length: { maximum: 10 }
  validates :voucher_amount, numericality: { greater_than: 0, lower_or_equal_than: 999999 },
    if: Proc.new { |d| d.voucher_amount.present? }

  validates :client_type, :products, :description,
    presence: true, length: { maximum: 250 }

  validates :comments, :actions_taken, :parcel, :guide_id, length: { maximum: 250 }
  validate :timeframe_between_devolutions, on: :create
  validate :guide_and_parcel, on: :update
  validate :voucher_folio_and_amount, on: :update

  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :taken, -> (opt) {
    return all unless opt.present?
    if opt == 'not_taken'
      where(user_id: nil)
    else
      where.not(user_id: nil)
    end
  }
  scope :solved, -> (opt) {
    return all unless opt.present?
    if opt.to_sym == :solved
      where.not(guide_id: nil).or(where.not(voucher_folio: nil))
    else
      where(guide_id: nil, voucher_folio: nil)
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
    return if self.rma.present?
    self.rma = Utils.new_alphanumeric_token(5)
  end

  def notificate_resolution
    if self.guide_id_changed? and self.guide_id.present?
      NotifyDevolutionTrackingIdJob.perform_async(self)
    elsif self.voucher_folio_changed? and self.voucher_folio.present?
      NotifyDevolutionVoucherJob.perform_async(self)
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

  def guide_and_parcel
    if (self.guide_id.present? and !self.parcel.present?)
      self.errors.add(:guide_id, :missing_parcel)
    elsif (self.parcel.present? and !self.guide_id.present?)
      self.errors.add(:parcel, :missing_guide_id)
    end
  end

  def voucher_folio_and_amount
    if (self.voucher_folio.present? and !self.voucher_amount.present?)
      self.errors.add(:voucher_folio, :missing_voucher_amount)
    elsif (self.voucher_amount.present? and !self.voucher_folio.present?)
      self.errors.add(:voucher_amount, :missing_voucher_folio)
    end
  end
end
