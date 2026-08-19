# frozen_string_literal: true

module ProjectTypes
  class BuildRoad < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      Road.create!(
        location_1: project_location,
        location_2: dest_location,
        road_type: road_type
      )

      update_workers!

      notify_starting_character
    end

    private

    def body
      I18n.t('events.projects.my_ended', project_info: project_info)
    end

    def project_info
      return unless project.project_descriptions.any?

      case project.project_type.key
      when 'build'
        build_project_info
      when 'discover_resource'
        discover_resource_project_info
      end
    end

    def project_location
      @project_location ||= project.location
    end

    def dest_location
      @dest_location ||= road_description.subject
    end

    def road_type
      @road_type ||= road_description.metadata['road_type']
    end

    def road_description
      @road_description ||= project.project_descriptions.road.first
    end

    def starting_character
      @starting_character ||= project.starting_character
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
