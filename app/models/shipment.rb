# Defines a shipment from one of the company's suppliers
class Shipment < ApplicationRecord
  include Timeable
  include Searchable

  STATUSES = %w[remissioned sent received processed]

  before_validation :set_hash_id, on: :create
  before_validation :set_status, on: :create

  has_many :shipment_products, dependent: :destroy
  belongs_to :origin_state
  belongs_to :supplier

  validates :hash_id, presence: true, length: { maximum: 12 },
    uniqueness: { case_sensitive: false }
  validates :estimated_arrival, presence: true
  validates :comments, length: { maximum: 250 }
  validates :status, inclusion: { in: STATUSES }

  scope :by_supplier, ->(id) { where(supplier_id: id) if id.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }

  private
  def set_hash_id
    return if self.hash_id.present?
    self.hash_id = Utils.new_alphanumeric_token(5).upcase
  end

  def set_status
    return if self.status.present?
    self.status = STATUSES.first
  end
end
