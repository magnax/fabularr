# frozen_string_literal: true

module ShipActions
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise Locations::MustBeOnShipError unless character_on_ship?
      raise ShipActions::InvalidUndockDirectionError if undock_coords.blank?

      Traveller.create!(subject: ship, start_location: @character.toplevel_location)
      ship.update!(coords: undock_coords)
    end

    private

    def character_on_ship?
      ship.present?
    end

    def undock_coords
      @undock_coords ||= begin
        return if direction_index.nil?

        loc_x, loc_y = @character.toplevel_location.coords.to_a

        x = loc_x + Math.cos(direction_angle) * Maps::UNDOCK_RADIUS
        y = loc_y + Math.sin(direction_angle) * Maps::UNDOCK_RADIUS

        Maps.location_type(x, y).in?(%w[water water_lake]) ? { x: x, y: y } : nil
      end
    end

    def direction_angle
      @direction_angle ||= (45 * direction_index) * (Math::PI / 180)
    end

    def direction_index
      Maps::UNDOCK_DIRECTIONS.find do |_k, v|
        v == @params[:direction]
      end&.first
    end

    def ship
      @ship ||= Ship.find_by(id: @character.location_id)
    end
  end
end
