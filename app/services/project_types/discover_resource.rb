# frozen_string_literal: true

module ProjectTypes
  class DiscoverResource < ApplicationService
    include Definitions::LocationResources

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      return unless discovered_resource

      LocationResource.create!(
        location_id: project.location_id, resource_id: discovered_resource.id
      )
      project.project_descriptions.create!(subject: discovered_resource)
    end

    private

    def discovered_resource
      return unless Resource.any?

      @discovered_resource ||= begin
        r_keys = RESOURCES[location.location_type.key.to_sym] & Resource.all.pluck(:key)
        resources = Resource.where(key: r_keys)

        resources.select do |rr|
          rr.resource_type_id.include?(ResourceType.find_by(key: 'food').id)
        end.sample
      end
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
