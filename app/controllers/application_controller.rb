class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Хелпер метод, доступный во вьюхах
  helper_method :current_user_can_edit?
  helper_method :current_user_is_admin?

  # Настройка для девайза — разрешаем обновлять профиль, но обрезаем
  # параметры, связанные со сменой пароля.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
        :account_update,
        keys: [:password, :password_confirmation, :current_password]
    )
  end

  # Вспомогательный метод, возвращает true, если текущий залогиненный юзер
  # может править указанную модель. Обновили метод — теперь на вход принимаем
  # event, или «дочерние» объекты
  def current_user_can_edit?(model)
    (user_signed_in? && current_user.is_admin?) || (
    user_signed_in? && (
    model.user == current_user ||
        (model.try(:book).present? && model.book.user == current_user)
    ))
  end

  def current_user_is_admin?
    user_signed_in? && current_user.is_admin?
  end
end
