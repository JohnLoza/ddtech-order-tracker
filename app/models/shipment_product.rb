# Defines a product in a shipment
class ShipmentProduct < ApplicationRecord
  belongs_to :shipment
  has_many :shipment_product_destinations, dependent: :destroy

  validates :ddtech_id, presence: true, length: { maximum: 12 }
end
