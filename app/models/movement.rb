class Movement < ApplicationRecord
  include Timeable

  belongs_to :user
  belongs_to :order

  DESCRIPTIONS = {
    new_order: 'new_order',
    supplied_order: 'supplied_order',
    assembled_order: 'assembled_order',
    packed_order: 'packed_order',
    sent_order: 'sent_order',
    holded_order: 'holded_order',
    released_order: 'released_order'
  }.freeze

  before_validation :set_description, on: :create
  before_save { self.data = data.strip if data.present? }

  validates :description,
    presence: true,
    length: { maximum: 200 },
    inclusion: { in: DESCRIPTIONS.values }

  validates :data, length: { maximum: 250 }

  private

  def set_description
    Rails.logger.debug "/// description: #{self.description}"
    unless self.description.present?
      self.description = "#{self.order.status}_order"
    end
    Rails.logger.debug "/// description: #{self.description}"
  end
end
