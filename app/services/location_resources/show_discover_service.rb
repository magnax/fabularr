# frozen_string_literal: true

module LocationResources
  class ShowDiscoverService < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      raise InvalidLocationError if invalid_location?

      {
        location_id: location.id,
        project_type_id: project_type_id
      }
    end

    private

    def invalid_location?
      location.blank? || !location.town?
    end

    def project_type_id
      ProjectType.find_by(key: 'discover_resource').id
    end

    def location
      @location ||= @character.location
    end
  end
end
