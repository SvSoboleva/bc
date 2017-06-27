class Book < ApplicationRecord
  belongs_to :user
  belongs_to :section

  validates :user, presence: true
  validates :section, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :author, presence: true, length: { maximum: 50 }
end
