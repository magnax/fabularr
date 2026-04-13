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
end
