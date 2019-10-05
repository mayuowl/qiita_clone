# frozen_string_literal: true

class Api::V1::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session

  alias current_user current_api_v1_user
  alias authenticate_user! authenticate_api_v1_user!
  alias user_signed_in? api_v1_user_signed_in?
end
