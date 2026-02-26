# frozen_string_literal: true

module Projects
  class JoinService < ApplicationService
    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      Worker.create!(project: project, character: @character)
    end

    private

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
