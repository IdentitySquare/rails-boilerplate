class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_password
    @user = current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)

      flash[:success] = "Your password has been updated"
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_back(fallback_location: edit_user_registration_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end