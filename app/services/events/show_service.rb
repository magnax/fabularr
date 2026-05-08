# frozen_string_literal: true

module Events
  class ShowService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      {
        buildings: location&.buildings,
        vehicles: location&.vehicles,
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
        Project.pending
               .joins(:starting_character, :project_type)
               .where(
                 project_types: { key: ProjectType::CREATE_LOCATION },
                 starting_character: { location_id: nil }
               ).where(
                 "length(lseg(starting_character.coords::point, point(#{@character.x}, #{@character.y}))) < ?", Character::MIN_HEARABLE_DISTANCE
               )
      end
    end

    def roads
      return if @character.travelling? || !@character.can_start_travel?

      toplevel_location.roads.map do |road|
        to_location = dest_location(road)
        {
          id: road.id,
          location_id: to_location.id,
          location_name: to_location.display_name(@character),
          type: I18n.t("roads.types.#{road.road_type}"),
          direction: Maps.locations_direction_text(toplevel_location, to_location)
        }
      end
    end

    def toplevel_location
      @toplevel_location ||= @character.toplevel_location
    end

    def town?
      location.present? && location.town?
    end

    def travel_info
      return unless @character.travelling?

      {
        location: traveller.start_location,
        dest_location: traveller_dest_location,
        traveller_id: traveller.id,
        speed: traveller.speed,
        direction: traveller.direction,
        percent: percent
      }
    end

    def dest_location(road)
      return if road.blank?
      return road.location_1 if road.location_2 == location

      road.location_2
    end

    def traveller_dest_location
      return if traveller.road.blank?
      return traveller.road.location_1 if traveller.road.location_2 == traveller.start_location

      traveller.road.location_2
    end

    def percent
      return if traveller.road.blank?

      Maps.calculate_percent(traveller, traveller.road).round(1)
    end

    def traveller
      @traveller ||= @character.traveller || location.traveller
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
