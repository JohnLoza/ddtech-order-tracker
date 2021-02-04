class Supplier < ApplicationRecord
  include SoftDeletable
  has_many :shipments

  validates :name, presence: true, length: { maximum: 50 }

  scope :order_by_name, ->(flow = :asc) { order(name: flow) }

  def to_s
    self.name
  end
end
