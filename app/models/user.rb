class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books
  has_many :lists
  has_many :chats

  before_validation :set_name, on: :create
  validates :name, presence: true, length: { maximum: 20 }

  mount_uploader :avatar, AvatarUploader

  private

  def set_name
    self.name = "Введите имя#{rand(777)}" if self.name.blank?
  end
end
