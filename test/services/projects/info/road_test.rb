# frozen_string_literal: true

require 'test_helper'

class ProjectsInfoRoadTest < ActiveSupport::TestCase
  def setup
    @location = create(:location, coords: { x: 300, y: 300 })
    @character = create(:character, location: @location)
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

  test 'location beyond building distance' do
    create(:location, coords: { x: 400, y: 290 })

    res = call_service(@location.id)

    assert_empty res[:locations]
  end
end
