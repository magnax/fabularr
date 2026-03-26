# frozen_string_literal: true

require 'test_helper'

class ProjectsCollectProgressServiceTest < ActiveSupport::TestCase
  def setup
    @project_check_time = DateTime.parse('2026-02-01 11:00:00')
  end

  def call_service(project_id)
    Projects::ProgressService.call(project_id)
  end

  test 'collect - worker with speed > 1' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    project = create(:project, :collect,
                     duration: 1000, elapsed: 0,
                     checked_at: nil)
    create(:worker, project: project,
                    character: create(:character),
                    left_at: nil, speed: 1.5)

    Timecop.freeze(time + 10.minutes) do
      assert_difference -> { project.reload.elapsed }, 900 do
        call_service(project.id)
      end
    end

    project.reload

    assert_equal time + 10.minutes, project.checked_at
  end
end
