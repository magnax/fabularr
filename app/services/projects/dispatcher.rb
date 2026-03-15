# frozen_string_literal: true

module Projects
  class Dispatcher < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      return if service_name.nil?

      "ProjectTypes::#{service_name}".constantize.call(project.id)
    end

    private

    def service_name
      @service_name ||= Project::DISPATCH_SERVICE[project_type.key]
    end

    def project_type
      @project_type ||= project.project_type
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
