# frozen_string_literal: true

module Projects
  class Info::Road < ApplicationService
    class InvalidLocationError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidLocationError if location.blank?

      {
        locations: nearby_locations_map.reject(&:nil?),
        project_type_id: project_type.id,
        order: nearby_locations.map { |l| "order[]=#{l[:id]}" }.join('&')
      }
    end

    private

    def nearby_locations_map
      nearby_locations.map.with_index do |nearby_location, index|
        locations_ids = nearby_location.roads.pluck(
          :location_1_id, :location_2_id
        ).flatten

        {
          id: nearby_location.id,
          index: index + 1,
          direction: Maps.locations_direction_text(location, nearby_location),
          name: nearby_location.display_name(@character),
          project_id: project(nearby_location)&.id,
          road: @character.location_id.in?(locations_ids)
        }
      end
    end

    def nearby_locations
      Location
        .joins(:location_class)
        .where.not(id: location.id)
        .where(location_class: { key: LocationClass::TOWN })
        .where("length(lseg(coords::point, point(#{location.x}, #{location.y}))) < ?", Location::ROAD_BUILD_DISTANCE)
        .order(Arel.sql('atan2(coords[1]-?, coords[0]-?)', location.y, location.x))
    end

    def location
      Location.find_by(id: @params[:location_id])
    end

    def project_type
      @project_type ||= ProjectType.find_by(key: @params[:type])
    end

    def project(dest_location)
      @project ||= @character.location.projects
                             .joins(:project_descriptions)
                             .where(project_type_id: project_type.id,
                                    project_descriptions: {
                                      description_type: ProjectDescription::ROAD, subject_id: dest_location.id
                                    }).first
    end
  end
end
