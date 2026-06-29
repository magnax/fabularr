# frozen_string_literal: true

module ProjectTypes
  class Machinery < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      location.location_objects.create(subject: created_item)
    end

    private

    def created_item
      ::Machinery.find_by(key: recipe.key)
    end

    def location
      @location ||= project.location
    end

    def recipe
      @recipe ||= project.recipe
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
