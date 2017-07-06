class Book < ApplicationRecord
  belongs_to :user
  belongs_to :section

  has_many :book_lists, dependent: :destroy
  has_many :lists, through: :book_lists, source: :list

  validates :user, presence: true
  validates :section, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :author, presence: true, length: { maximum: 50 }
end
