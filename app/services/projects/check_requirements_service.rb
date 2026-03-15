module Projects
  class CheckRequirementsService < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      project.update!(ready: requirements_met)
    end

    private

    def requirements_met
      resource_in_descriptions.all? { |d| d.amount == d.amount_needed }
    end

    def resource_in_descriptions
      project.project_descriptions
             .where(description_type: ProjectDescription::RESOURCE_IN)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
