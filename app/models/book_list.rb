class BookList < ApplicationRecord
  belongs_to :list
  belongs_to :book

  validates :book, presence: true
  validates :list, presence: true
  validates :book, uniqueness: { scope: :list_id }
end
