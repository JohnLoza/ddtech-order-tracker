# frozen_string_literal: true

# User definition class
class User < ApplicationRecord
  include Searchable
  include Timeable
  include SoftDeletable

  ROLES = {
    admin: 'admin',
    assembler: 'assembler',
    human_resources: 'human_resources',
    packer: 'packer',
    digital_guides: 'digital_guides',
    shipments: 'shipments',
    warehouse: 'warehouse',
    observer: 'observer'
  }.freeze

  before_save :downcase_email
  has_secure_password

  has_many :orders
  has_many :movements
  has_many :notes

  validates :name, :email, presence: true, length: { maximum: 50 }
  validates :role, presence: true, inclusion: { in: ROLES.values }

  validates :password, presence: true, length: { in: 6..20 }, on: :create

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, confirmation: true

  scope :non_admin, -> { where.not(role: User::ROLES[:admin]) }
  scope :not, ->(ids) { where.not(id: ids) }
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
