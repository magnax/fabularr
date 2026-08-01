# frozen_string_literal: true

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
    Timecop.unfreeze
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
    Timecop.unfreeze
  end

  test 'project ongoing and checked for the first time' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    project = create(:project, :discover_resource,
                     duration: 900, elapsed: 300,
                     checked_at: nil)
    create(:worker, project: project,
                    character: create(:character),
                    left_at: nil)

    Timecop.freeze(time + 10.minutes) do
      assert_difference -> { project.reload.elapsed }, 600 do
        call_service(project.id)
      end
    end

    project.reload

    assert_equal time + 10.minutes, project.checked_at
    Timecop.unfreeze
  end

  test 'project checked after expected duration' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    project = create(:project, :discover_resource,
                     duration: 1000, elapsed: 900,
                     checked_at: DateTime.parse('2026-02-01 11:15:00'))
    create(:worker, project: project,
                    character: create(:character),
                    left_at: nil)

    Timecop.freeze(time + 20.minutes) do
      assert_difference -> { project.reload.elapsed }, 100 do
        assert_difference -> { Event.count }, 1 do
          call_service(project.id)
        end
      end
    end

    project.reload

    assert_equal time + 20.minutes, project.checked_at
    assert_equal project.elapsed, project.duration
    Timecop.unfreeze
  end

  test 'repeated project' do
    location = create(:location)
    character = create(:character, location: location)
    stone = create(:resource, key: 'stone', daily_rate: 1440)
    create(:location_resource, resource: stone, location: location, status: true)
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    project = create(:project, :collect, starting_character: character, location: location,
                                         duration: 600, elapsed: 0, checked_at: nil)
    create(:project_description, :resource_out, project: project,
                                                subject: stone, amount_needed: 10)
    desc = create(:project_description, :repeat, project: project, amount: 3)
    create(:worker, project: project, character: character, left_at: nil)

    Timecop.freeze(time + 11.minutes)
    call_service(project.id)

    project.reload

    # assert resource being deposited after first repeat, description updated
    inv_stone = character.reload.inventory_objects.resource.find_by(subject_id: stone.id)
    assert_equal 10, inv_stone.amount
    assert_equal 2, desc.reload.amount
    assert_equal 60, project.elapsed

    # second round
    Timecop.freeze(time + 21.minutes)
    assert_difference -> { ProjectDescription.count } => -1 do
      call_service(project.id)
    end

    project.reload

    # assert resource being added after second repeat, description updated
    inv_stone = character.reload.inventory_objects.resource.find_by(subject_id: stone.id)
    assert_equal 20, inv_stone.amount
    assert_equal 60, project.elapsed

    # last round
    Timecop.freeze(time + 31.minutes)
    call_service(project.id)

    project.reload

    # assert resource being added after last repeat, description updated
    inv_stone = character.reload.inventory_objects.resource.find_by(subject_id: stone.id)
    assert_equal 30, inv_stone.amount
    assert_equal 600, project.elapsed

    Timecop.unfreeze
  end
end
