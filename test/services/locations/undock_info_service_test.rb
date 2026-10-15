# frozen_string_literal: true

require 'test_helper'

class LocationsUndockInfoServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location, seashore: true)
    ship = create(:location, :ship, parent_location: @location)
    @character = create(:character, location: ship)
  end

  def call_service(ship_id)
    Locations::UndockInfoService.call(@character, ship_id)
  end

  test 'show directions' do
    @location.update!(coords: { x: 227, y: 417 })

    res = call_service(@character.location_id)

    assert_equal 3, res[:directions].length
    assert_equal %w[sw w nw], res[:directions]
  end
end
