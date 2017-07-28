class Chat < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable

  validates :theme, presence: true, length: {maximum: 100}

end
