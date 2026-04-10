# frozen_string_literal: true

module Events
  class ShowService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {
        character: @character,
        location: location,
        characters: characters,
        events: Events::FetchEvents.call(@character),
        items: items,
        location_resources: location&.location_resources,
        buildings: location&.buildings,
        projects: location&.projects&.pending&.includes(:starting_character, :project_type),
        travel_info: travel_info
      }
    end

    private

    def items
      return {} if location.blank?

      {
        resources: location&.location_objects&.includes(:subject)&.resource,
        items: location&.location_objects&.item
      }
    end

    def travel_info
      return unless @character.travelling?

      {
        location: @character.traveller.start_location,
        traveller_id: @character.traveller.id,
        speed: @character.traveller.speed,
        direction: @character.traveller.direction
      }
    end

    def characters
      @characters ||= location&.characters || []
    end

    def location
      @location ||= @character.location
    end
  end
end
