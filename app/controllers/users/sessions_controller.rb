# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # Take into account acts_as_paranoid deleted users
    if (resource = resource_class.only_deleted.find_by_email(params[resource_name][:email]))
      if resource.valid_password?(params[resource_name][:password]) && resource.recover!
        flash[:notice] = "Your account has been restored!"
        # TODO: send email to user saying that their account has been restored

        sign_in resource
      end
    end

    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super(resource)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

end
