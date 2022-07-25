class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def check_admin_permission!
    render json: { error: "You don't have permission for this action!" }, status: :forbidden unless current_user.admin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[is_admin])
  end

  def json_request?
    request.format.json?
  end
end
