# frozen_string_literal: true

# User definition class
class User < ApplicationRecord
  include Searchable
  include SoftDeletable

  ROLES = {
    admin: 'admin',
    assembler: 'assembler',
    human_resources: 'human_resources',
    packer: 'packer',
    parcel_guides_generator: 'parcel_guides_generator',
    shipments: 'shipments',
    warehouse: 'warehouse'
  }.freeze

  before_save :downcase_email
  has_secure_password

  has_many :orders

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true
  validates :role, presence: true

  validates :password, presence: true, length: { in: 6..20 }, on: :create

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, confirmation: true

  scope :non_admin, -> { where.not(role: User::ROLES[:admin]) }
  scope :not, ->(ids) { where.not(id: ids) }
  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, ->(way = :asc) { order(name: way) }
  scope :by_role, ->(role) { where(role: role) if role.present? }

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}"
  end

  def admin?
    role == ROLES[:admin]
  end

  def role?(role)
    if admin?
      true
    else
      self.role == ROLES[role]
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
