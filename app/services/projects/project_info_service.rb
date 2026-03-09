# frozen_string_literal: true

module Projects
  class ProjectInfoService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      {
        location_resource: location_resource,
        location: location_resource.location,
        project_type_id: project_type.id,
        amount: amount
      }
    end

    private

    def amount
      86_400.0 / location_resource.resource.base_speed_per_unit
    end

    def location_resource
      @location_resource ||= LocationResource.find_by(id: @params[:location_resource_id])
    end

    def project_type
      @project_type ||= ProjectType.find_by(key: @params[:type])
    end
  end
end
