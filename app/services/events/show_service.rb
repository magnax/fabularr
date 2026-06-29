# frozen_string_literal: true

module Events
  class ShowService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      read_events!

      {
        animals: animals,
        buildings: location&.buildings,
        character: @character,
        characters: map_characters,
        events: events,
        items: items,
        location: location,
        location_info: Locations::InfoService.call(@character),
        location_resources: visible_resources,
        project: project,
        projects: Projects::VisibleProjects.call(@character),
        roads: roads,
        travel_info: travel_info,
        vehicles: location&.vehicles
      }
    end

    private

    def animals
      return if location.blank?

      location.animal_packs.map do |pack|
        {
          key: pack.animal.key,
          quantity: pack.amount
        }
      end
    end

    def read_events!
      @character.visible_events.where(read_at: nil).find_each do |event|
        event.update(read_at: DateTime.current)
      end
    end

    def map_characters
      characters.uniq.map do |ch|
        {
          id: ch.id,
          name: @character.name_for(ch),
          location: other_location(ch)
        }
      end
    end

    def events
      @events ||= Events::FetchEvents.call(@character)
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
        items: objects&.item,
        machines: objects&.machinery,
        resources: objects&.includes(:subject)&.resource
      }
    end

    def objects
      @objects ||= location&.location_objects
    end

    def visible_resources
      @visible_resources ||= location&.location_resources&.visible
    end

    def roads
      return if @character.travelling? || !@character.can_start_travel?

      toplevel_location.roads.map do |road|
        to_location = road.destination_location(location)
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

    def project
      @character.project
    end

    def travel_info
      return unless @character.travelling?

      {
        location: traveller.start_location,
        dest_location: traveller.destination_location,
        traveller_id: traveller.id,
        speed: traveller.speed,
        direction: traveller.direction,
        percent: percent
      }
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
      Characters::TravellingCharactersService.call(@character)
    end

    def location
      @location ||= @character.location
    end
  end
end
