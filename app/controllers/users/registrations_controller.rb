# frozen_string_literal: true

module Users
  # Users::RegistrationsController is responsible for handling user registration and related actions.
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :user_type, :password, :password_confirmation])
    end
  end
end
