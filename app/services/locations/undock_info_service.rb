# frozen_string_literal: true

module Locations
  class UndockInfoService < ApplicationService
    DIRECTIONS = {
      0 => 'e',
      1 => 'se',
      2 => 's',
      3 => 'sw',
      4 => 'w',
      5 => 'nw',
      6 => 'n',
      7 => 'ne'
    }.freeze

    RADIUS = 20

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
      DIRECTIONS.map do |index, dir|
        angle = (45 * index) * (Math::PI / 180)
        x = location.x + Math.cos(angle) * RADIUS
        y = location.y + Math.sin(angle) * RADIUS
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
