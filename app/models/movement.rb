class Movement < ApplicationRecord
  include Timeable
  include CustomGroupable
  include Searchable

  belongs_to :user
  belongs_to :order

  DESCRIPTIONS = {
    new_order: 'new_order',
    warehouse_entry_order: 'warehouse_entry_order',
    supplied_order: 'supplied_order',
    assemble_entry_order: 'assemble_entry_order',
    assembled_order: 'assembled_order',
    packed_order: 'packed_order',
    sent_order: 'sent_order',
    holded_order: 'holded_order',
    released_order: 'released_order'
  }.freeze

  before_validation :set_description, on: :create
  before_save { self.data = data.strip if data.present? }

  validates :description, presence: true, inclusion: { in: DESCRIPTIONS.values }

  validates :data, length: { maximum: 250 }

  scope :sent, -> { where(description: Movement::DESCRIPTIONS[:sent_order]) }
  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_parcel, -> (parcel) { joins(:order).where(orders: { parcel: parcel }) if parcel.present? }

  private

  def set_description
    unless self.description.present?
      self.description = "#{self.order.status}_order"
    end
  end
end
