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
        characters: map_characters,
        events: Events::FetchEvents.call(@character),
        items: items,
        location: location,
        location_info: location_info,
        location_resources: location&.location_resources,
        projects: projects,
        roads: roads,
        travel_info: travel_info
      }
    end

    private

    def map_characters
      characters.uniq.map do |ch|
        {
          id: ch.id,
          name: @character.name_for(ch),
          location: other_location(ch)
        }
      end
    end

    def other_location(other_character)
      return if other_character.location == @character.location

      {
        id: other_character.location_id,
        name: location_display_name(other_character)
      }
    end

    def location_display_name(other_character)
      name = other_character.location.display_name(@character)
      return name unless other_character.location.vehicle?

      location_type = I18n.t("vehicles.#{other_character.location.location_type.key}")
      "#{name} [#{location_type}]"
    end

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

    def location_info
      {
        toplevel_location_name: toplevel_location&.display_name(@character),
        toplevel_location_id: toplevel_location&.id,
        sublocation_name: sublocation_name,
        sublocation_id: sublocation_id,
        location_type: location_type
      }
    end

    def sublocation_name
      return if location.blank? || town?

      location.display_name(@character)
    end

    def sublocation_id
      return if location.blank? || town?

      location.id
    end

    def location_type
      return if location.blank?

      loc_type = I18n.t "#{location_type_i18n_key}.#{location.location_type.key}"
      return "[#{loc_type}]" unless location.town?

      "[#{loc_type}][#{location.x.round(1)}, #{location.y.round(1)}]"
    end

    def location_type_i18n_key
      location.town? ? 'locations' : location.location_class.key.pluralize
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
      @characters ||= [@character] + location_characters + travelling_characters
    end

    def location_characters
      return [] if location.blank?

      location.hearable_characters
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
