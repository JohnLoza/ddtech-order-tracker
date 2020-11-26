class Tag < ApplicationRecord
  has_many :order_tags, dependent: :destroy
  has_many :orders, through: :order_tags

  STYLES = [
    'tag m-1 red-tag text-dark',
    'tag m-1 red-tag text-light',
    'tag m-1 pink-tag text-dark',
    'tag m-1 pink-tag text-light',
    'tag m-1 purple-tag text-light',
    'tag m-1 deep-purple-tag text-light',
    'tag m-1 indigo-tag text-light',
    'tag m-1 blue-tag text-dark',
    'tag m-1 blue-tag text-light',
    'tag m-1 light-blue-tag text-dark',
    'tag m-1 light-blue-tag text-light',
    'tag m-1 cyan-tag text-dark',
    'tag m-1 cyan-tag text-light',
    'tag m-1 teal-tag text-dark',
    'tag m-1 teal-tag text-light',
    'tag m-1 green-tag text-dark',
    'tag m-1 green-tag text-light',
    'tag m-1 light-green-tag text-dark',
    'tag m-1 light-green-tag text-light',
    'tag m-1 lime-tag text-dark',
    'tag m-1 yellow-tag text-dark',
    'tag m-1 amber-tag text-dark',
    'tag m-1 orange-tag text-dark',
    'tag m-1 orange-tag text-light',
    'tag m-1 deep-orange-tag text-dark',
    'tag m-1 brown-tag text-light',
    'tag m-1 grey-tag text-dark',
    'tag m-1 grey-tag text-light',
    'tag m-1 blue-grey-tag text-dark',
    'tag m-1 blue-grey-tag text-light'
  ]

  before_save { self.name = name.strip }

  validates :name, :css_class, presence: true
  validates :name, length: { maximum: 25 }

  def to_s
    name
  end
end
