# frozen_string_literal: true

class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:account, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:account, :email)
  end
end
