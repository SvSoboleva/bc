class List < ApplicationRecord
  belongs_to :user
  has_many :book_lists, dependent: :destroy
  has_many :books, through: :book_lists, source: :book

  validates :name, presence: true, length: { maximum: 20 }

end
