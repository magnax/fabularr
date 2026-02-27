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

      elapsed = 0
      workers.each do |worker|
        t_start = if worker.created_at >= project.checked_at
                    worker.created_at
                  else
                    project_checked_at
                  end
        t_end = worker.left_at || DateTime.current

        elapsed += t_end - t_start
      end

      project.update(elapsed: project.elapsed + elapsed)
    end

    private

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end
