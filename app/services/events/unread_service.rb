# frozen_string_literal: true

module Events
  class UnreadService < ApplicationService
    def initialize(user_id)
      @user_id = user_id
    end

    def call
      user.characters.inject({}) do |res, char|
        res.merge!(char.id => char.visible_events.unread.length)
      end
    end

    private

    def user
      @user ||= User.find_by(id: @user_id)
    end
  end
end
