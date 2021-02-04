class OriginState < ApplicationRecord
  has_many :shipments

  validates :name, presence: true
  validates :estimated_shipment_days, presence: true, numericality: { greater_than: 0 }
end
