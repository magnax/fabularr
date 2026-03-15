# frozen_string_literal: true

module Projects
  class ProgressService < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      return unless project.elapsed < project.duration
      return unless project.workers.any?
      return unless workers.any?

      current_time = 0
      elapsed = 0

      workers.each do |worker|
        current_time = DateTime.current
        t_start = if created_after_checked?(worker)
                    worker.created_at
                  else
                    project.checked_at
                  end
        t_end = worker.left_at || current_time.to_time

        elapsed += (t_end - t_start)
      end

      if (project.duration - project.elapsed) > elapsed
        project.update(elapsed: project.elapsed + elapsed, checked_at: current_time)

        broadcast_progress!
      else
        project.update(elapsed: project.duration, checked_at: current_time)
        Projects::EndService.call(project.id)
      end
    end

    private

    def workers
      @workers ||= project.workers.active +
                   Worker
                   .where(project_id: project.id)
                   .where('left_at > ?', project.checked_at)
    end

    def broadcast_progress!
      ActionCable.server.broadcast(
        "location_#{project.location_id}",
        {
          type: 'project',
          id: project.id,
          progress: (project.elapsed.to_f / project.duration * 100.0).round(1)
        }
      )
    end

    def created_after_checked?(worker)
      project.checked_at.nil? ||
        (worker.created_at >= project.checked_at)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
