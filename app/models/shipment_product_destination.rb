# A product from a shipment may be sent to different warehouses
class ShipmentProductDestination < ApplicationRecord
  belongs_to :shipment_product

  validates :units, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :destination, presence: true, length: { maximum: 50 }
end
