# frozen_string_literal: true

module Events
  class ShowService < ApplicationService
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

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
        location: location_hash,
        location_info: Locations::InfoService.call(@character),
        location_resources: visible_resources,
        project: project,
        projects: projects,
        roads: roads,
        travel_info: travel_info,
        vehicles: location&.vehicles
      }
    end

    private

    def animals
      return if location.blank?

      location.animal_packs.includes(:animal).map do |pack|
        I18n.t("animals.#{pack.animal.key}.p")
      end.sort.join(', ')
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

    def location_hash
      return {} if location.blank?

      {
        id: location.id,
        parent_location_id: location.parent_location_id,
        parent_location_name: location.parent_location&.display_name(@character),
        town: location.town?,
        lakeshore: location.lakeshore,
        seashore: location.seashore
      }
    end

    def items
      return {} if location.blank?

      {
        items: objects&.item,
        machines: machines,
        resources: objects&.includes(:subject)&.non_zero_resource
      }
    end

    def machines
      @machines ||= objects&.machinery&.map do |machine|
        {
          id: machine.id,
          key: machine.subject.key,
          in_use: machine.in_use?
        }
      end
    end

    def objects
      @objects ||= location&.location_objects
    end

    def projects
      Projects::VisibleProjects.call(@character).map do |project|
        {
          id: project.id,
          ready: project.ready,
          can_join: project.joinable?,
          name: project.name(@character, short: true).upcase_first,
          progress: project.progress,
          starting_character_link: link_to(
            @character.name_for(project.starting_character),
            character_name_url(
              character_id: project.starting_character_id, only_path: true
            )
          )
        }
      end
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
