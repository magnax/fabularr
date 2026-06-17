# frozen_string_literal: true

require 'test_helper'

class ProjectsLeaveServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @char_skill = create(:character_skill, :exploring,
                         character: @character, level: 0, status: true)
  end

  def call_service
    Projects::LeaveService.call(@character)
  end

  test 'leaves project and increases skill - awkwardly' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 2.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 0.01568, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end

  test 'leaves project and increases skill - promote awkwardly to novicely' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 128.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 1.00376, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end

  test 'leaves project and increases skill - novicely (slower)' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)
    @char_skill.update!(level: 1)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 139.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 1.98101, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end

  test 'leaves project and increases skill - efficiently (even slower)' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)
    @char_skill.update!(level: 2)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 157.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 2.99724, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end

  test 'leaves project and increases skill - skillfully (even slower)' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)
    @char_skill.update!(level: 3)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 174.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 3.9947, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end

  test 'leaves project and increases skill - promote to expertly' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)
    @char_skill.update!(level: 3)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 180.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 4.0, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end

  test 'leaves project and increases skill - expertly (no change)' do
    time = DateTime.parse('2026-06-01 9:00')
    project = create(:project, :discover_resource)
    @char_skill.update!(level: 4)

    Timecop.travel(time)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      Timecop.freeze(time + 20.days)
      call_service
    end

    assert worker.reload.left_at
    assert_equal 4.0, @character.reload.character_skills.last.level.round(5)

    Timecop.unfreeze
  end
end
