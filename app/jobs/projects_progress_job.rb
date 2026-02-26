# frozen_string_literal: true

class ProjectsProgressJob
  include Sidekiq::Job

  def perform
    ids = Worker.active.pluck(:project_id).uniq
    Project.where(id: ids).find_each do |project|
      project.update(elapsed: project.elapsed + 300) unless project.elapsed >= project.duration
    end

    s = Setting.find_by key: 'projects'
    return unless s&.value == '1'

    ::ProjectsProgressJob.perform_in 5.minutes
  end
end
