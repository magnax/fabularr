# frozen_string_literal: true

module Locations
  class ExamineShowService < ApplicationService
    class InvalidLocationTypeError < StandardError; end

    def initialize(character)
      @character = character
    end

    def call
      {
        project_type_id: ProjectType.find_by(key: 'create_location').id,
        location_type: location_type_key,
        can_create: can_create
      }
    end

    private

    def location_type_key
      location_type = Maps.location_type(@character.x, @character.y)
      raise InvalidLocationTypeError unless location_type.is_a?(LocationType)

      location_type.key
    end

    def can_create
      descriptions.none?
    end

    def descriptions
      @descriptions ||=

        ProjectDescription.location
                          .where(subject_id: nil)
                          .where.not(metadata: nil)
                          .where("length(
                            lseg(
                              point(
                                metadata['coords']['x']::float,
                                metadata['coords']['y']::float
                              ),
                              point(:x, :y)
                            )
                          ) < :dist",
                                 x: @character.x,
                                 y: @character.y,
                                 dist: Character::MIN_HEARABLE_DISTANCE)
    end
  end
end
