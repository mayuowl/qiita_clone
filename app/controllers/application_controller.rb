# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  # FIXME: devise_token_auth の current_user を導入するまでのダミーコード
  def current_user
    @current_user ||= User.first
  end

end
