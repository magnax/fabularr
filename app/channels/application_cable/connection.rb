# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      reject_unauthorized_connection unless verified_user

      verified_user
    end

    def verified_user
      remember_token = User.encrypt(cookies[:remember_token])
      @verified_user ||= User.find_by(remember_token: remember_token)
    end
  end
end
