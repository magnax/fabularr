require 'test_helper'

class ProjectsProgressServiceTest < ActiveSupport::TestCase
  def setup
    @project_check_time = DateTime.parse('2026-02-01 11:00:00')
  end

  def call_service(project_id)
    Projects::ProgressService.call(project_id)
  end

  test 'simple case - project not started, no work was done' do
    project = create(:project, duration: 900, elapsed: 0)

    assert_difference -> { project.reload.elapsed }, 0 do
      call_service(project.id)
    end
  end

  test 'project started, no work was done from last check' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    project = create(:project,
                     duration: 900, elapsed: 300,
                     checked_at: DateTime.parse('2026-02-01 11:20:00'))
    create(:worker, project: project,
                    character: create(:character),
                    left_at: DateTime.parse('2026-02-01 11:15:00'))

    Timecop.freeze(time + 30.minutes) do
      assert_difference -> { project.reload.elapsed }, 0 do
        call_service(project.id)
      end
    end
  end

  test 'project started, some work was done and finished from last check' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    project = create(:project,
                     duration: 900, elapsed: 300,
                     checked_at: DateTime.parse('2026-02-01 11:19:00'))
    create(:worker, project: project,
                    character: create(:character),
                    left_at: DateTime.parse('2026-02-01 11:15:00'))
    Timecop.freeze(time + 20.minutes)
    # worker started after last checking and worked for 5 minutes (300 seconds)
    create(:worker, project: project,
                    character: create(:character),
                    left_at: DateTime.parse('2026-02-01 11:25:00'))

    Timecop.freeze(time + 30.minutes) do
      assert_difference -> { project.reload.elapsed }, 300 do
        call_service(project.id)
      end
    end
  end
end
