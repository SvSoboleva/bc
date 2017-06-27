class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books

  before_validation :set_name, on: :create
  validates :name, presence: true, length: { maximum: 35 }

  private

  def set_name
    self.name = "Введите имя#{rand(777)}" if self.name.blank?
  end
end
