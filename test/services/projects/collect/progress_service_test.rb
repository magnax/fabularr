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
    Timecop.unfreeze
  end

  test 'collect - repeating project, first repeat' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    stone = create(:resource, key: 'stone')
    project = create(:project, :collect,
                     duration: 600, elapsed: 0,
                     checked_at: nil)
    project_description = create(:project_description, :repeat,
                                 project: project, amount: 2)
    create(:project_description, :resource_out,
           project: project, subject: stone, amount: 2)
    create(:worker, project: project,
                    character: create(:character),
                    left_at: nil)

    Timecop.freeze(time + 11.minutes) do
      assert_difference -> { InventoryObject.count } => 1 do
        call_service(project.id)
      end
    end

    project.reload
    assert_equal 1, project_description.reload.amount

    Timecop.unfreeze
  end

  test 'collect - repeating project, last repeat' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    stone = create(:resource, key: 'stone')
    project = create(:project, :collect,
                     duration: 600, elapsed: 0,
                     checked_at: nil)
    create(:project_description, :repeat, project: project, amount: 1)
    create(:project_description, :resource_out,
           project: project, subject: stone, amount: 2)
    create(:worker, project: project,
                    character: create(:character),
                    left_at: nil)

    Timecop.freeze(time + 11.minutes) do
      assert_difference -> { InventoryObject.count } => 1,
                        -> { ProjectDescription.count } => -1 do
        call_service(project.id)
      end
    end

    Timecop.unfreeze
  end
end
