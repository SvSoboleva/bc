class Section < ApplicationRecord
  has_many :books
  validates :name, presence: true, length: { maximum: 35 }
end
