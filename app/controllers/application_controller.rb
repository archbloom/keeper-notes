class ApplicationController < ActionController::Base
  protect_from_forgery fallback: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  acts_as_token_authentication_handler_for User

  protected

  # handle extra param name for the devise user model
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password])
  end
end
