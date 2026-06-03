# frozen_string_literal: true

module Locations
  class EnterLocationService < ApplicationService
    class MaxCharactersExceededError < StandardError; end
    class MaxCapacityExceededError < StandardError; end

    def initialize(character, location_id)
      @character = character
      @location_id = location_id
      @previous_location_id = @character.location_id
    end

    def call
      raise MaxCharactersExceededError if max_characters?
      raise MaxCapacityExceededError if capacity_exceeded?

      @character.update!(location: location)
      create_events!
    end

    private

    def max_characters?
      location.characters.count == location.max_characters
    end

    def capacity_exceeded?
      return false if location.max_capacity.nil?

      total_weight > location.max_capacity
    end

    def total_weight
      Character::WEIGHT + @character.carrying_weight + location.stored_weight
    end

    def create_events!
      create_character_event!
      create_others_events!
    end

    def create_character_event!
      Event.create!(
        body: I18n.t(
          'events.enter_location', count: location.characters.count - 1, **locations_args
        ),
        receiver_character: @character,
        location: previous_location
      )
    end

    def create_others_events!
      create_location_events!(previous_location, 'leave')
      create_location_events!(location, 'enter')
    end

    def create_location_events!(location, direction)
      location.characters.find_each do |char|
        next if char == @character

        Event.create!(
          body: I18n.t(
            "events.#{direction}_location_other",
            character_link: @character.char_id,
            **locations_args
          ),
          receiver_character: char,
          location: location
        )
      end
    end

    def locations_args
      @locations_args ||= {
        in_place: location.loc_id,
        out_place: previous_location.loc_id
      }
    end

    def previous_location
      @previous_location ||= Location.find_by(id: @previous_location_id)
    end

    def location
      @location ||= Location.find_by(id: @location_id)
    end
  end
end
