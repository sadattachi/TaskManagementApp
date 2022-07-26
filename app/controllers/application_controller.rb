# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def auth_user
    render json: { error: 'You need to log in to continue!' }, status: :unauthorized unless user_signed_in?
  end

  def check_admin_permission!
    unless current_user.admin?
      forbidden_message("You don't have permission for this action!")
      return false
    end
    true
  end

  def check_admin_or_manager_permission!
    if !current_user.admin? && !current_user.manager?
      forbidden_message("You don't have permission for this action!")
      return false
    end
    true
  end

  def check_deactivated
    unless current_user.worker.active
      forbidden_message("Deactivated users don't have access to any actions!")
      return false
    end
    true
  end

  def forbidden_message(error)
    render json: { error: error }, status: :forbidden
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[is_admin])
  end

  def json_request?
    request.format.json?
  end
end
