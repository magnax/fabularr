# frozen_string_literal: true

class ProjectsProgressJob
  include Sidekiq::Job

  def perform
    Project.pending.find_each do |project|
      Projects::ProgressService.call(project.id)
    end

    s = Setting.find_by key: 'projects'
    return unless s&.value == '1'

    ::ProjectsProgressJob.perform_in 5.minutes
  end
end
