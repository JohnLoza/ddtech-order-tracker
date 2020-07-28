class Movement < ApplicationRecord
  include Timeable

  belongs_to :user
  belongs_to :order

  DESCRIPTIONS = {
    new_order: 'new_order',
    supplied_order: 'supplied_order',
    assembled_order: 'assembled_order',
    packed_order: 'packed_order',
    sent_order: 'sent_order'
  }.freeze

  before_validation :set_description, on: :create

  validates :description, presence: true, length: { maximum: 200 }
  validates :description, inclusion: { in: DESCRIPTIONS.values }

  validates :data, length: { maximum: 200 }

  private

  def set_description
    self.description = "#{self.order.status}_order"
  end
end
