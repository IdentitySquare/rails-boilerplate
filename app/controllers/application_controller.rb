class ApplicationController < ActionController::Base
  protect_from_forgery

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  impersonates :user
  before_action :set_paper_trail_whodunnit

  protected

  def pundit_user
    current_admin_user || current_user
  end

  def user_for_paper_trail
    current_admin_user || true_user
  end

  private

  def user_not_authorized
    flash[:error] = t('application.not_authorized')
    redirect_to(request.referrer || root_path)
  end

end
