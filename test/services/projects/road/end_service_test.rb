# frozen_string_literal: true

require 'test_helper'

class ProjectsRoadEndServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test 'creates a new path' do
    end_location = create(:location)
    project = create(:project, :road, location: @location,
                                      starting_character: @character)
    create(:project_description, :road, project: project, subject: end_location,
                                        metadata: { road_type: Road::PATH })

    assert_difference -> { Road.count } => 1,
                      -> { Event.count } => 1 do
      call_service(project.id)
    end

    road = Road.last
    assert_equal Road::PATH, road.road_type
    assert_equal [@location.id, end_location.id].sort,
                 [road.location_1_id, road.location_2.id].sort
  end
end
