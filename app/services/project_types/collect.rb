# frozen_string_literal: true

module ProjectTypes
  class Collect < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      LocationObject.create!(
        location_id: project.location_id, subject: resource, amount: amount, unit: resource.unit
      )

      resource_description.update!(amount: amount)
    end

    private

    def resource
      @resource ||= resource_description.subject
    end

    def resource_description
      @resource_description ||= project.project_descriptions
                                       .where(subject_type: 'Resource')
                                       .last
    end

    def amount
      @amount ||= (resource_description.amount * ((rand * 0.2) + 0.9)).to_i
    end

    def location
      @location ||= project.location
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
