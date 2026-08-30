# frozen_string_literal: true

module Events
  class CreateAndBroadcastService < ApplicationService
    def initialize(character, body)
      @character = character
      @body = body
    end

    def call
      event = Event.create!(
        body: @body,
        receiver_character: @character
      )

      ActionCable.server.broadcast(
        "char_#{@character.id}",
        { type: 'event', event_id: event.id }
      )

      event
    end
  end
end
