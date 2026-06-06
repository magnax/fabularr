# frozen_string_literal: true

module Locations
  class CreateService < ApplicationService
    def initialize(coords, location_type, params = {})
      @coords = coords
      @location_type = location_type
      @params = params
    end

    def call
      @location = Location.create!(location_type: @location_type,
                                   location_class: LocationClass.find_by(key: 'town'),
                                   coords: @coords, **@params)

      create_resources!

      @location
    end

    private

    def create_resources!
      Resource.raw_resource.sample(rand(2..9)).each do |resource|
        @location.location_resources.create!(resource: resource)
      end
    end
  end
end
