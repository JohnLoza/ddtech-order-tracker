class Movement < ApplicationRecord
  include Timeable

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

  validates :description,
    presence: true,
    length: { maximum: 200 },
    inclusion: { in: DESCRIPTIONS.values }

  validates :data, length: { maximum: 250 }

  scope :today, -> { where(created_at: Date.today.all_day) }
  scope :beetween_dates, -> (start_date, end_date) {
    return all unless start_date.present? and end_date.present?
    start_date = start_date.to_date
    end_date = end_date.to_date
    where(created_at: start_date.beginning_of_day..end_date.end_of_day)
  }

  private

  def set_description
    unless self.description.present?
      self.description = "#{self.order.status}_order"
    end
  end
end
