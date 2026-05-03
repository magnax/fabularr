# frozen_string_literal: true

module Events
  class ShowService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {
        buildings: location&.buildings,
        character: @character,
        characters: characters.uniq,
        events: Events::FetchEvents.call(@character),
        items: items,
        location: location,
        location_resources: location&.location_resources,
        projects: projects,
        roads: roads,
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

    def projects
      if @character.location
        location&.projects&.pending&.includes(:starting_character, :project_type)
      else
        Project.pending.joins(:starting_character).where(starting_character: { location_id: nil }).where(
          "length(lseg(starting_character.coords::point, point(#{@character.x}, #{@character.y}))) < ?", Character::MIN_HEARABLE_DISTANCE
        )
      end
    end

    def roads
      return if @character.travelling? || !town?

      location.roads.map do |road|
        to_location = dest_location(road)
        {
          id: road.id,
          location_id: to_location.id,
          location_name: to_location.display_name(@character),
          type: I18n.t("roads.types.#{road.road_type}"),
          direction: Maps.locations_direction_text(location, to_location)
        }
      end
    end

    def dest_location(road)
      return road.location_1 if road.location_2 == location

      road.location_2
    end

    def town?
      location.present? && location.town?
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
