class Category < ApplicationRecord
  belongs_to :vertical

  validates :name, :state, presence: true
  validates :name, uniqueness: true
end
