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
        characters: characters.uniq,
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
      @characters ||= [@character] + (location&.characters || []) + travelling_characters
    end

    def travelling_characters
      return [] unless @character.travelling?

      Character
        .where(id: Traveller.character.pluck(:subject_id) - [@character.id])
        .where(
          "length(
            lseg(coords::point, point(#{@character.x},#{@character.y}))
          ) <= ? ", Character::MIN_HEARABLE_DISTANCE
        )
    end

    def location
      @location ||= @character.location
    end
  end
end
