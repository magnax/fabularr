# frozen_string_literal: true

require 'test_helper'

class MapsTest < ActiveSupport::TestCase
  test '#location_type invalid position' do
    assert_raises Maps::InvalidPositionError do
      Maps.location_type(-10, -10)
    end
  end

  test '#location_type exception' do
    Maps.expects(:full_map)
        .times(1..10)
        .returns(Magick::ImageList.new('test/fixtures/invalid_map.png').first)

    assert_raises Maps::InvalidMapColorError do
      Maps.location_type(5, 5)
    end
  end

  test '#location_type - water' do
    assert_equal 'water', Maps.location_type(10, 10)
  end

  test '#location_type - border' do
    assert_equal 'border', Maps.location_type(110, 540)
  end

  test '#location_type - habitable' do
    swamp = create(:location_type, key: 'swamp')

    assert_equal swamp, Maps.location_type(300, 400)
  end

  test 'locations_directions_text' do
    location_1 = create(:location, coords: { x: 100, y: 100 })

    location_2 = create(:location)

    coords = [
      [{ x: 100, y: 10 }, 'north'],
      [{ x: 120, y: 60 }, 'north-north-east'],
      [{ x: 150, y: 50 }, 'north-east'],
      [{ x: 160, y: 70 }, 'east-north-east'],
      [{ x: 200, y: 100 }, 'east'],
      [{ x: 160, y: 130 }, 'east-south-east'],
      [{ x: 150, y: 150 }, 'south-east'],
      [{ x: 130, y: 160 }, 'south-south-east'],
      [{ x: 100, y: 150 }, 'south'],
      [{ x: 70, y: 160 }, 'south-south-west'],
      [{ x: 50, y: 150 }, 'south-west'],
      [{ x: 40, y: 130 }, 'west-south-west'],
      [{ x: 50, y: 100 }, 'west'],
      [{ x: 40, y: 70 }, 'west-north-west'],
      [{ x: 50, y: 50 }, 'north-west'],
      [{ x: 70, y: 40 }, 'north-north-west']
    ]

    coords.each do |coord|
      location_2.update!(coords: coord[0])
      assert_equal coord[1], Maps.locations_direction_text(location_1, location_2)
    end
  end

  test 'direction_text' do
    results = [
      [0, 'east'],
      [45, 'south-east']
    ]

    results.each do |result|
      assert_equal result[1], Maps.direction_text(result[0])
    end
  end
end
