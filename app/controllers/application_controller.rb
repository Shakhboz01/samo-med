class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :check_expiry_date
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'Вам не разрешено совершить эту операцию.'
    redirect_to(request.referrer || root_path)
  end

  def check_expiry_date
    expiry_date = Date.new(2024, 11, 15)
    if Date.today > expiry_date
      render plain: 'Sizning tarif rejangiz tugadi.', status: :forbidden
    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:telegram_chat_id])
  end
end
