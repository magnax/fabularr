# frozen_string_literal: true

module ProjectTypes
  class CreateLocation < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      location = Location.create!(location_type: location_type,
                                  location_class: LocationClass.find_by(key: 'town'),
                                  coords: character.coords)
      character.update!(location: location)
      character.traveller.destroy
      project.project_descriptions.create!(
        description_type: ProjectDescription::LOCATION, subject: location
      )
    end

    private

    def location_type
      @location_type ||= Maps.location_type(*position)
    end

    def position
      [character.x, character.y]
    end

    def character
      @character ||= project.starting_character
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
