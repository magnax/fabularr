# frozen_string_literal: true

module Projects
  class VisibleProjects < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      return location_projects if @character.location

      location_create_projects
    end

    def location_projects
      @character.location&.projects&.pending&.includes(:starting_character, :project_type)
    end

    def location_create_projects
      Project.pending
             .includes(:starting_character, :project_type)
             .joins(:project_type, :project_descriptions)
             .where(project_types: { key: 'create_location' })
             .where(project_descriptions: { description_type: 'location' })
             .where('length('\
              'lseg('\
                "point(#{@character.x}, #{@character.y}), "\
                'point('\
                  "project_descriptions.metadata['coords']['x']::float, "\
                  "project_descriptions.metadata['coords']['y']::float"\
                ')'\
              ')'\
            ') < ?', Character::MIN_HEARABLE_DISTANCE)
    end
  end
end
