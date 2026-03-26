# frozen_string_literal: true

module Projects
  class ProgressService < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      return unless pending_project?
      return unless project.workers.any?
      return unless workers.any?

      if (project.duration - project.elapsed) > elapsed_time
        progress_project!
      else
        end_project!
      end
    end

    private

    def pending_project?
      project.elapsed < project.duration
    end

    def progress_project!
      project.update(elapsed: project.elapsed + elapsed_time, checked_at: DateTime.current)

      broadcast_progress!
    end

    def end_project!
      project.update(elapsed: project.duration, checked_at: DateTime.current)

      Projects::EndService.call(project.id)
    end

    def elapsed_time
      @elapsed_time ||= calculate_elapsed_time
    end

    def calculate_elapsed_time
      workers.inject(0) do |elapsed, worker|
        current_time = DateTime.current
        t_start = if created_after_checked?(worker)
                    worker.created_at
                  else
                    project.checked_at
                  end
        t_end = worker.left_at || current_time.to_time

        elapsed + ((t_end - t_start) * worker.speed)
      end
    end

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
