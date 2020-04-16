class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :set_paper_trail_whodunnit

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

  def pundit_user
    current_admin_user || current_user
  end

  def user_for_paper_trail
    if current_admin_user
      current_admin_user.id
    elsif current_user
      current_user.id
    else
      'Unknown User'
    end
  end

  def info_for_paper_trail
    if current_admin_user
      class_name = AdminUser
    elsif current_user
      class_name = User
    end

    {whodunnit_type: class_name}
  end

  private

  def user_not_authorized
    flash[:error] = t('application.not_authorized')
    redirect_to(request.referrer || root_path)
  end

end
