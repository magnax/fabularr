# frozen_string_literal: true

module ProjectTypes
  class Vehicle < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      Location.create!(
        location_definitions.merge(
          coords: location.coords,
          location_type: location_type,
          location_class: LocationClass.find_by(key: recipe.recipe_type),
          metadata: { base_speed: all_definitions[:base_speed] },
          name: name,
          parent_location: location
        )
      )
    end

    private

    def location_definitions
      @location_definitions ||= all_definitions.except(:base_speed)
    end

    def all_definitions
      @all_definitions ||= Definitions::LocationTypes::CONFIG_VEHICLES[location_type.key]
    end

    def location_type
      @location_type ||= LocationType.find_by(key: recipe.key)
    end

    def name
      project.settings['name']
    end

    def recipe
      @recipe ||= project.recipe
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
