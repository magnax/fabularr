# frozen_string_literal: true

require 'test_helper'

class ProjectsRoadEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test 'creates a new path' do
    start_location = create(:location)
    end_location = create(:location)
    project = create(:project, :road, location: start_location)
    create(:project_description, :road, project: project, subject: end_location,
                                        metadata: { road_type: Road::PATH })

    assert_difference -> { Road.count } => 1 do
      call_service(project.id)
    end

    road = Road.last
    assert_equal Road::PATH, road.road_type
    assert_equal [start_location.id, end_location.id].sort,
                 [road.location_1_id, road.location_2.id].sort
  end
end
