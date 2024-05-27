class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'Вам не разрешено совершить эту операцию.'
    redirect_to(request.referrer || root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:telegram_chat_id])
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.врач? # Replace :дилер with the actual role check
      qr_scanner_path
    elsif resource.регистратор?
      new_buyer_path
    else
      super
    end
  end
end
