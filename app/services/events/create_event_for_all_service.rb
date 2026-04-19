# frozen_string_literal: true

module Events
  class CreateEventForAllService < ApplicationService
    def initialize(characters, body, except: nil)
      @characters = characters
      @body = body
      @except = except
      @locations = []
    end

    def call
      @characters.each do |ch|
        next if ch == @except

        Event.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: @body
        )

        if ch.location
          @locations << ch.location
        else
          ActionCable.server.broadcast("char_#{ch.id}", { type: 'event', body: @body })
        end
      end

      @locations.uniq.each do |location|
        ActionCable.server.broadcast("location_#{location.id}", { type: 'event', body: @body })
      end
    end
  end
end
