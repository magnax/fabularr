# frozen_string_literal: true

module Projects::UpdateWorkers
  def update_workers!
    @project.workers.active.find_each do |worker|
      worker.update!(left_at: DateTime.current)
    end
  end
end
