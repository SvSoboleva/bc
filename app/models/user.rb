class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:vkontakte]

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

  def self.find_for_vkontakte_oauth(access_token)
    # Как выглядит объект access_token можно посмотреть на странице гема
    # https://github.com/mamantoha/omniauth-vkontakte#authentication-hash
    # Мы достаем из этого объекта url и provider, вместе они формируют
    # уникального пользователя
    url = access_token.info.urls.Vkontakte
    provider = access_token.provider

    # Ищем таких пользователей методом where, а методом
    # first_or_create! мы либо выбираем первого (если такой нашелся)
    # либо создаем нового с такими параметрами (url, provider),
    # к этому юзеру в случае создания также будет применен блок
    where(url: url, provider: provider).first_or_create! do |user|
      # В блоке мы прописываем пользователю имя, которое получили от ВКонтатке
      user.name = access_token.info.name
      # Формируем email из id пользователя ВКонтакте
      user.email = "#{access_token.uid}@vk.com"
      # И генерируем ему случайный надежный парроль
      # пользоваться им никто не будет, но формально по нему можно войти
      user.password = Devise.friendly_token[0,20]
    end
  end
end
