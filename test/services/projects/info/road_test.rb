# frozen_string_literal: true

require 'test_helper'

class ProjectsInfoRoadTest < ActiveSupport::TestCase
  def setup
    @location = create(:location, coords: { x: 300, y: 300 })
    @character = create(:character, location: @location)
    @project_type = create(:project_type, key: 'road')
  end

  def call_service(location_id)
    Projects::Info::Road.call(@character,
                              { type: 'road' }.merge(location_id: location_id))
  end

  test 'invalid location' do
    assert_raises Projects::Info::Road::InvalidLocationError do
      call_service(0)
    end
  end

  test 'no other locations exist' do
    res = call_service(@location.id)

    assert_empty res[:locations]
  end

  test 'location within building distance' do
    near_location = create(:location, coords: { x: 350, y: 250 })

    res = call_service(@location.id)

    assert_equal near_location.id, res[:locations].sole[:id]
  end

  test 'location within building distance, but with project started' do
    near_location = create(:location, coords: { x: 350, y: 250 })

    project = create(:project, project_type: @project_type,
                               location: @character.location)
    create(:project_description, :road, project: project, subject: near_location)

    res = call_service(@location.id)

    assert_equal near_location.id, res[:locations].sole[:id]
    assert_equal project.id, res[:locations].sole[:project_id]
  end

  test '2 locations within building distance, ordered by direction' do
    near_location_1 = create(:location, coords: { x: 370, y: 320 })
    near_location_2 = create(:location, coords: { x: 350, y: 250 })

    res = call_service(@location.id)

    assert_equal 2, res[:locations].length
    first_location = res[:locations].find { |l| l[:id] == near_location_2.id }
    assert_equal 1, first_location[:index]

    second_location = res[:locations].find { |l| l[:id] == near_location_1.id }
    assert_equal 2, second_location[:index]
  end

  test 'location beyond building distance' do
    create(:location, coords: { x: 400, y: 290 })

    res = call_service(@location.id)

    assert_empty res[:locations]
  end
end
