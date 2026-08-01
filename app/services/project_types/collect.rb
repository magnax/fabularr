# frozen_string_literal: true

module ProjectTypes
  class Collect < ApplicationService
    class NoSuchResourceError < StandardError; end

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      raise NoSuchResourceError if location_resource.blank?

      InventoryObjects::IncreaseAmountService.call(
        receiving_character, resource.key, resource_description.amount_needed
      )

      resource_description.update!(amount: amount)
    end

    private

    def location_resource
      @location_resource ||= visible_location_resources.find_by(resource_id: resource.id)
    end

    def visible_location_resources
      @visible_location_resources ||= location.location_resources.visible
    end

    # TODO: case when starting character is not present in project's location
    def receiving_character
      @receiving_character ||= project.starting_character
    end

    def resource
      @resource ||= resource_description.subject
    end

    def resource_description
      @resource_description ||= project.project_descriptions.resource_out.last
    end

    def amount
      @amount ||= resource_description.amount.to_i
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
