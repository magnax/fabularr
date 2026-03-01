# frozen_string_literal: true

module Events
  class CreateEventForAllService < ApplicationService
    def initialize(location, body, except: nil)
      @location = location
      @body = body
      @except = except
    end

    def call
      @location.characters.each do |ch|
        next if ch == @except

        @location.events.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: @body
        )
      end

      ActionCable.server.broadcast("location_#{@location.id}", { type: 'event', body: @body })
    end
  end
end
