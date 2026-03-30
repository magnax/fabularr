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
      session = Session.find_by(id: cookies.signed[:session_id])

      User.find_by(id: session&.user_id)
    end
  end
end
