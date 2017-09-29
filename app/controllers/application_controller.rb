class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Хелпер метод, доступный во вьюхах
  helper_method :current_user_can_edit?
  helper_method :current_user_is_admin?
  helper_method :current_user_can_add_book?

  # Настройка для девайза — разрешаем обновлять профиль, но обрезаем
  # параметры, связанные со сменой пароля.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
        :account_update,
        keys: [:password, :password_confirmation, :current_password]
    )
  end

  def current_user_can_edit?(model)
    user_signed_in? && model.user == current_user
  end

  def current_user_is_admin?
    user_signed_in? && current_user.is_admin?
  end

  def current_user_can_add_book?
    user_signed_in? && current_user.lists.any?
  end

end
