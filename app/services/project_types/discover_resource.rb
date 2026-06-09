# frozen_string_literal: true

module ProjectTypes
  class DiscoverResource < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      discovered_resource&.update!(status: true)

      project.project_descriptions.create!(
        description_type: ProjectDescription::LOCATION_RESOURCE,
        subject: discovered_resource&.resource
      )
    end

    private

    def discovered_resource
      @discovered_resource ||= location.location_resources.available.first
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
