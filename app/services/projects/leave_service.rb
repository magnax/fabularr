# frozen_string_literal: true

module Projects
  class LeaveService < ApplicationService
    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      worker.update!(left_at: Time.current)
    end

    private

    def worker
      project.workers.where(character: @character, left_at: nil)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
