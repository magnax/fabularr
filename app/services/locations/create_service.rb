# frozen_string_literal: true

module Locations
  class CreateService < ApplicationService
    def initialize(coords, params = {})
      @coords = coords
      @params = params
    end

    def call
      @location = Location.create!(location_type: location_type,
                                   location_class: LocationClass.find_by(key: 'town'),
                                   coords: @coords, **@params)

      LocationResources::CreateService.call(@location)
      AnimalPacks::CreateService.call(@location)

      @location
    end

    private

    def location_type
      @location_type ||= Maps.location_type(*position)
    end

    def position
      return [@coords.x, @coords.y] if @coords.is_a?(ActiveRecord::Point)

      [@coords['x'], @coords['y']]
    end
  end
end
