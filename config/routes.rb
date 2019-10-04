# frozen_string_literal: true

Rails.application.routes.draw do
  root "homes#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations"
      }
      resources :articles, defaults: { format: :json }
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
