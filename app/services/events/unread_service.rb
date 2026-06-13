# frozen_string_literal: true

module Events
  class UnreadService < ApplicationService
    def initialize(user_id)
      @user_id = user_id
    end

    def call
      characters.inject({}) do |res, char|
        res.merge!(char.id => char.count)
      end
    end

    private

    def characters
      @characters ||= Character
                      .where(user_id: user.id)
                      .joins(
                        'LEFT JOIN events ON '\
                        'events.receiver_character_id = characters.id'
                      )
                      .where(events: { read_at: nil })
                      .group('characters.id')
                      .select('characters.id, COUNT(events.id)')
    end

    def user
      @user ||= User.find_by(id: @user_id)
    end
  end
end
