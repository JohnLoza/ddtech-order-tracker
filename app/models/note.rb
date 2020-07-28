class Note < ApplicationRecord
  include Timeable

  belongs_to :user
  belongs_to :order

  before_save { self.message = message.strip }

  validates :message, presence: true
end
