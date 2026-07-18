# frozen_string_literal: true

require 'test_helper'

class LocationsCreateServiceTest < ActiveSupport::TestCase
  def setup
    create(:location_class, key: 'town')
  end

  def call_service(coords)
    Locations::CreateService.call(coords)
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
    Maps.expects(:location_type).with(coords.x, coords.y).returns(location_type)

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
    Maps.expects(:location_type).with(coords.x, coords.y).returns(location_type)
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
    require_relative '../../../db/seeds/animals'

    location_type = create(:location_type, key: 'mountains')
    coords = ActiveRecord::Point.new(x: 200, y: 200)
    Maps.expects(:location_type).with(coords.x, coords.y).returns(location_type)
    create(:resource, :raw_food, key: 'stone')

    assert_difference -> { Location.count } => 1 do
      call_service(coords)
    end

    assert Location.last.animal_packs.any?
  ensure
    AnimalPack.destroy_all
  end
end
