class Tag < ApplicationRecord
  has_many :order_tags, dependent: :destroy
  has_many :orders, through: :order_tags

  STYLES = [
    'tag red-tag text-dark',
    'tag red-tag text-light',
    'tag pink-tag text-dark',
    'tag pink-tag text-light',
    'tag purple-tag text-light',
    'tag deep-purple-tag text-light',
    'tag indigo-tag text-light',
    'tag blue-tag text-dark',
    'tag blue-tag text-light',
    'tag light-blue-tag text-dark',
    'tag light-blue-tag text-light',
    'tag cyan-tag text-dark',
    'tag cyan-tag text-light',
    'tag teal-tag text-dark',
    'tag teal-tag text-light',
    'tag green-tag text-dark',
    'tag green-tag text-light',
    'tag light-green-tag text-dark',
    'tag light-green-tag text-light',
    'tag lime-tag text-dark',
    'tag yellow-tag text-dark',
    'tag amber-tag text-dark',
    'tag orange-tag text-dark',
    'tag orange-tag text-light',
    'tag deep-orange-tag text-dark',
    'tag brown-tag text-light',
    'tag grey-tag text-dark',
    'tag grey-tag text-light',
    'tag blue-grey-tag text-dark',
    'tag blue-grey-tag text-light'
  ]

  before_save { self.name = name.strip }

  validates :name, :css_class, presence: true
  validates :name, length: { maximum: 25 }

  def to_s
    name
  end

  def to_param
    "#{self.id}-#{self.name}"
  end
end
