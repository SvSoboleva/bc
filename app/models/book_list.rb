class BookList < ApplicationRecord
  belongs_to :list
  belongs_to :book

  validates :user, presence: true
  validates :book, presence: true
  validates :book, uniqueness: { scope: :list_id }
end
