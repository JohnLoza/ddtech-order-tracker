# frozen_string_literal: true

# Devolution definition class
class Devolution < ApplicationRecord
  include Searchable
  include Timeable

  before_validation :set_rma, on: :create
  before_save { self.rma = rma.upcase }
  before_save { self.email = email.downcase }
  before_update :send_guide_id
  after_create { NotifyRmaJob.perform_async(self) }

  belongs_to :user, optional: true

  validates :rma, presence: true, length: { is: 10 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :client_name, :telephone, :client_type, :order_id, :products,
    :description, presence: true, length: { maximum: 250 }
  validates :devolution_address, :comments, :actions_taken, :parcel, :guide_id, length: { maximum: 250 }

  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_parcel, -> (parcel) { where(parcel: parcel) if parcel.present? }

  def to_s
    "##{rma}"
  end

  private
  def set_rma
    self.rma = Utils.new_alphanumeric_token(7)
  end

  def send_guide_id
    if self.guide_id_changed? or self.parcel_changed?
      NotifyDevolutionTrackingIdJob.perform_async(self)
    end
  end
end
