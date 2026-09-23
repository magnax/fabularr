# frozen_string_literal: true

module Events
  class CreateEventForAllService < ApplicationService
    def initialize(characters, body, except: nil)
      @characters = characters - [except].flatten.compact
      @body = body
    end

    def call
      @characters.each do |ch|
        Event.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: @body
        )

        ActionCable.server.broadcast("char_#{ch.id}", { type: 'event', body: @body })
      end
    end
  end
end
