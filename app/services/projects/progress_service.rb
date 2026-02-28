module Projects
  class ProgressService < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      return unless project.elapsed < project.duration
      return unless project.workers.any?

      workers = project.workers.active + Worker.where(project_id: project.id).where('left_at > ?', project.checked_at)

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

      elapsed = project.duration - project.elapsed if (project.duration - project.elapsed) < elapsed
      project.update(elapsed: project.elapsed + elapsed, checked_at: current_time)
    end

    private

    def created_after_checked?(worker)
      project.checked_at.nil? ||
        (worker.created_at >= project.checked_at)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
