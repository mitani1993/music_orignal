class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    root_path 
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :area_id, :profession_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :area_id, :profession_id, :youtube, :profile, :image])
  end
end
