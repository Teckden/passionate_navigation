class Vertical < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
