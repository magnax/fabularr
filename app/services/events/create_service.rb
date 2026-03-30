# frozen_string_literal: true

module Events
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      event = Event.create!(
        @params.merge(
          character: @character, location: location
        )
      )

      ActionCable.server.broadcast(
        "location_#{location.id}",
        {
          type: 'event', event_id: event.id
        }
      )
    end

    private

    def location
      @location ||= @character.location
    end
  end
end
