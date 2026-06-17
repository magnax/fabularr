# frozen_string_literal: true

require 'test_helper'

class ProjectsRoadLeaveServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @char_skill = create(:character_skill, :building,
                         character: @character, level: 0, status: true)
  end

  def call_service
    Projects::LeaveService.call(@character)
  end

  test 'leaves project and increases skill' do
    time = DateTime.parse('2026-06-01 9:00')

    start_location = create(:location)
    end_location = create(:location)
    project = create(:project, :road, location: start_location)
    create(:project_description, :road, project: project, subject: end_location,
                                        metadata: { road_type: Road::PATH })

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
end
