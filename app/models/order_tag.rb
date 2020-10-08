class OrderTag < ApplicationRecord
  belongs_to :order
  belongs_to :tag
end

