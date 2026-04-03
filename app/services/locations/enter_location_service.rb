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
        body: I18n.t(
          'events.enter_location', in_place: location.name,
                                   out_place: previous_location.name, count: location.characters.count - 1
        ),
        receiver_character: @character,
        location: previous_location
      )
    end

    def create_others_events!
      create_previous_location_events!
      create_entered_location_events!
    end

    def create_previous_location_events!
      previous_location.characters.find_each do |char|
        next if char == @character

        Event.create!(
          body: I18n.t('events.leave_location_other', character_link: @character.char_id,
                                                      in_place: location.name,
                                                      out_place: previous_location.name),
          receiver_character: char,
          location: previous_location
        )
      end
    end

    def create_entered_location_events!
      location.characters.find_each do |char|
        next if char == @character

        Event.create!(
          body: I18n.t('events.enter_location_other', character_link: @character.char_id,
                                                      in_place: location.name,
                                                      out_place: previous_location.name),
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
