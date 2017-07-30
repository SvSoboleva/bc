class Book < ApplicationRecord
  include PgSearch
  pg_search_scope :search, against: [:title, :author],
                  using: {tsearch: {dictionary: "russian"}}
  belongs_to :user
  belongs_to :section

  has_many :book_lists, dependent: :destroy
  has_many :lists, through: :book_lists, source: :list
  has_many :comments, as: :commentable

  validates :user, presence: true
  validates :section, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :author, presence: true, length: { maximum: 50 }
  validates :title, uniqueness: true

  mount_uploader :book_url, BookUploader
end
