# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # Take into account acts_as_paranoid deleted users
    if (resource = resource_class.only_deleted.find_by_email(params[resource_name][:email]))

      if resource.recover!
        flash[:notice] = "Your account has been restored!"
        # TODO: send email to user saying that their account has been restored
      end

      # Copied from Warden::Strategies database_authenticatable:
      if resource.valid_password?(params[resource_name][:password])
        sign_in resource
        redirect_to after_sign_up_path_for(resource) and return
      else
        flash[:notice] += " You can sign in with your old password or reset your password to set a new one."
        redirect_to new_session_path(resource_class) and return
      end

    else
      super
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    # default soft deletes
    super do
      # if user permanently wants to delete their account
      if params[:really_destroy]
        resource.destroy_fully!
        flash[:notice] = "Bye! Your account has been deleted permanently. We hope to see you again soon."
      end
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    stored_location_for(resource) || super(resource)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end