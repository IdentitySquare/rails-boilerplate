class ApplicationController < ActionController::Base
  protect_from_forgery

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  impersonates :user
  before_action :set_paper_trail_whodunnit

  before_action :set_default_meta_tags

  before_action :store_user_location!, if: :storable_location?
  before_action :ensure_signup_complete!

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

  def storable_location?
    request.get? &&
    is_navigational_format? &&
    !devise_controller? &&
    !request.xhr? &&
    !params[:action] == 'finish_signup'
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def ensure_signup_complete!
    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet (we did not get an email from oauth)
    if user_signed_in? && !current_user.finished_signup? && !current_page?(action: 'finish_signup')
      redirect_to finish_signup_user_path
    end
  end

end
