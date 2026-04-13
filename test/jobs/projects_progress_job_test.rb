# frozen_string_literal: true

require 'test_helper'

class ProjectsProgressJobTest < ActiveSupport::TestCase
  def call_job
    ProjectsProgressJob.perform_sync
  end

  test 'update position' do
    time = DateTime.parse('2026-04-11 09:00')
    Timecop.freeze(time)
    project = create(:project, :discover_resource,
                     duration: 900, elapsed: 300, checked_at: time)
    create(:worker, project: project, character: create(:character), left_at: nil)

    Timecop.freeze(time + 2.minutes)
    call_job

    assert_equal 420, project.reload.elapsed
    Timecop.unfreeze
  end

  test 'schedule next run' do
    create(:setting, key: 'projects', value: '1')

    Sidekiq.testing!(:fake) do
      call_job
      assert_equal 1, ProjectsProgressJob.jobs.size
    end
  end
end
