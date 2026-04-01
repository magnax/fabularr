# frozen_string_literal: true

module Locations
  class EnterLocationService < ApplicationService
    def initialize(character, location_id)
      @character = character
      @location_id = location_id
      @previous_location_id = @character.location_id
    end

    def call
      @character.update!(location: location)
      create_events!
    end

    private

    def create_events!
      create_character_event!
      create_others_events!
    end

    def create_character_event!
      Event.create!(
        body: 'you entered somewhere',
        receiver_character: @character,
        location: previous_location
      )
    end

    def create_others_events!
      previous_location.characters.find_each do |char|
        next if char == @character

        Event.create!(
          body: 'you see someone entering',
          receiver_character: char,
          location: previous_location
        )
      end

      location.characters.find_each do |char|
        next if char == @character

        Event.create!(
          body: 'you see someone leaving',
          receiver_character: char,
          location: location
        )
      end
    end

    def previous_location
      @previous_location ||= Location.find_by(id: @previous_location_id)
    end

    def location
      @location ||= Location.find_by(id: @location_id)
    end
  end
end
