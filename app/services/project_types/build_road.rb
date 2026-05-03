# frozen_string_literal: true

module ProjectTypes
  class BuildRoad < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      Road.create!(
        location_1: project_location,
        location_2: dest_location,
        road_type: road_type
      )
    end

    private

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

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
