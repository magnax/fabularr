# frozen_string_literal: true

require 'test_helper'

class LocationsCreateServiceTest < ActiveSupport::TestCase
  def setup
    create(:location_class, key: 'town')
  end

  def call_service(coords)
    Locations::CreateService.call(coords)
  end

  def set_map_expectations!(pos_x, pos_y, location_type)
    Maps.expects(:location_type).with(pos_x, pos_y).returns(location_type)
    Maps.expects(:seashore?).with(pos_x, pos_y).returns(false)
    Maps.expects(:lakeshore?).with(pos_x, pos_y).returns(false)
  end

  test 'create location and location resources - beach' do
    %w[cod gold limestone mud obsidian oil pearls pike salt seashells soda].each do |key|
      create(:resource, :raw_resource, key: key)
    end
    create(:resource, :raw_food, key: 'carrots')
    create(:resource, :raw_food, key: 'seaweeds')
    create(:resource, :raw_resource, key: 'roses')
    create(:resource, :raw_resource, key: 'sand')
    location_type = create(:location_type, key: 'beach')
    coords = ActiveRecord::Point.new(x: 200, y: 200)
    set_map_expectations!(coords.x, coords.y, location_type)

    assert_difference -> { Location.count } => 1 do
      call_service(coords)
    end

    assert_includes [2, 3, 4], LocationResource.count

    resources_available = Location.last.location_resources.available
    first_resource = resources_available.filter { |r| r.sorting == 1 }
    assert_equal 'seaweeds', first_resource.sole.resource.key

    second_resource = resources_available.filter { |r| r.sorting == 2 }
    assert_equal 'sand', second_resource.sole.resource.key
  end

  test 'create location and location resources - mountains, only stone' do
    %w[gold silver diamonds chromium cobalt emerald mushrooms
       nickel olives taconite salmon rainbow_trout].each do |key|
      create(:resource, :raw_resource, key: key)
    end
    location_type = create(:location_type, key: 'mountains')
    coords = ActiveRecord::Point.new(x: 200, y: 200)
    set_map_expectations!(coords.x, coords.y, location_type)
    create(:resource, :raw_food, key: 'carrots')
    create(:resource, :raw_food, key: 'stone')
    create(:resource, :raw_resource, key: 'olives')

    assert_difference -> { Location.count } => 1 do
      call_service(coords)
    end

    resources_available = Location.last.location_resources.available
    first_resource = resources_available.filter { |r| r.sorting == 1 }
    assert_equal 'stone', first_resource.sole.resource.key
  end

  test 'create location and animal packs' do
    Seeds::Animals.call

    location_type = create(:location_type, key: 'mountains')
    coords = ActiveRecord::Point.new(x: 200, y: 200)
    set_map_expectations!(coords.x, coords.y, location_type)
    create(:resource, :raw_food, key: 'stone')

    assert_difference -> { Location.count } => 1 do
      call_service(coords)
    end

    assert Location.last.animal_packs.any?
  ensure
    AnimalPack.destroy_all
  end

  test 'create location on the sea shore' do
    Maps.expects(:load_map)
        .times(1)
        .returns(Magick::ImageList.new('test/fixtures/simple_map.png').first)

    create(:location_type, key: 'meadow')
    create(:location_type, key: 'fields')
    create(:location_type, key: 'lakeside')

    coords_land = ActiveRecord::Point.new(x: 30, y: 30)
    coords_lakeshore = ActiveRecord::Point.new(x: 25, y: 90)
    coords_seashore = ActiveRecord::Point.new(x: 88, y: 90)

    create(:resource, :raw_food, key: 'rice')

    assert_difference -> { Location.count } => 1 do
      call_service(coords_land)

      location = Location.last
      assert_equal 30, location.x
      assert_not location.seashore
      assert_not location.lakeshore
    end

    assert_difference -> { Location.count } => 1 do
      call_service(coords_seashore)

      location = Location.last
      assert_equal 88, location.x
      assert location.seashore
      assert_not location.lakeshore
    end

    assert_difference -> { Location.count } => 1 do
      call_service(coords_lakeshore)

      location = Location.last
      assert_equal 25, location.x
      assert_not location.seashore
      assert location.lakeshore
    end
  end
end
