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
      []
    end

    def ship
      @ship ||= Ship.find_by(id: @ship_id)
    end
  end
end
