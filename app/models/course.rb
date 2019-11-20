class Course < ApplicationRecord
  belongs_to :category

  validates :name, :state, :author, presence: true
end
