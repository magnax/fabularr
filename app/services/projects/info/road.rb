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
        locations: nearby_locations_map
      }
    end

    private

    def nearby_locations_map
      nearby_locations.map do |nearby_location|
        {
          id: nearby_location.id,
          name: nearby_location.display_name(@character),
          direction: Maps.locations_direction_text(location, nearby_location)
        }
      end
    end

    def nearby_locations
      Location
        .where.not(id: location.id)
        .where("length(lseg(coords::point, point(#{location.x}, #{location.y}))) < ?", Location::ROAD_BUILD_DISTANCE)
    end

    def location
      Location.find_by(id: @params[:location_id])
    end
  end
end
