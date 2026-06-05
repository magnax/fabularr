# frozen_string_literal: true

module Locations
  class CreateService < ApplicationService
    def initialize(coords, location_type)
      @coords = coords
      @location_type = location_type
    end

    def call
      Location.create!(location_type: @location_type,
                       location_class: LocationClass.find_by(key: 'town'),
                       coords: @coords)
    end
  end
end
