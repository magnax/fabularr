# frozen_string_literal: true

module Locations
  class UndockInfoService < ApplicationService
    def initialize(character, ship_id)
      @character = character
      @ship_id = ship_id
    end

    def call
      raise Locations::MustBeOnShipError unless character_on_ship?

      {
        directions: directions
      }
    end

    private

    def character_on_ship?
      @character.location&.ship? && @character.location.id == ship.id
    end

    def directions
      Maps::UNDOCK_DIRECTIONS.map do |index, dir|
        angle = (45 * index) * (Math::PI / 180)
        x = location.x + Math.cos(angle) * Maps::UNDOCK_RADIUS
        y = location.y + Math.sin(angle) * Maps::UNDOCK_RADIUS
        Maps.location_type(x, y).in?(%w[water water_lake]) ? dir : nil
      end.compact
    end

    def ship
      @ship ||= Ship.find_by(id: @ship_id)
    end

    def location
      @location ||= @character.toplevel_location
    end
  end
end
