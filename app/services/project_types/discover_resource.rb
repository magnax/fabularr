# frozen_string_literal: true

module ProjectTypes
  class DiscoverResource < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      LocationResource.create!(location_id: project.location_id)
    end

    private

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
