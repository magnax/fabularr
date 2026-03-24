# frozen_string_literal: true

module Projects
  class JoinService < ApplicationService
    class ProjectNotFoundError < StandardError; end

    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      raise ProjectNotFoundError if project.blank?
      return unless can_join?

      Worker.create!(project: project, character: @character)
    end

    private

    def can_join?
      Recipes::CheckToolRequirementsService.call(@character, project)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
