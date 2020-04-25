class ApplicationController < ActionController::Base
  protect_from_forgery

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  impersonates :user
  before_action :set_paper_trail_whodunnit

  before_action :set_default_meta_tags

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

  def set_default_meta_tags
    set_meta_tags generator: 'Identity Square / www.identitysquare.com'
    set_meta_tags viewport: 'width=device-width, initial-scale=1'
  end

end
