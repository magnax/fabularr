# frozen_string_literal: true

require 'test_helper'

class EventsShowServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    Events::ShowService.call(@character)
  end

  test 'characters info' do
    other_char = create(:character, location: @character.location)

    res = call_service

    assert_equal [@character.id, other_char.id].sort, res[:characters].pluck(:id).sort
  end

  test 'travel info' do
    traveller = create(:traveller, subject: @character)
    @character.update!(location: nil, coords: { x: 100, y: 100 })

    res = call_service

    ch = res[:characters].sole
    assert_equal @character.id, ch[:id]
    assert_nil ch[:location]
    assert_equal traveller.speed, res[:travel_info][:speed]
    assert_equal traveller.direction, res[:travel_info][:direction]
    assert_equal traveller.id, res[:travel_info][:traveller_id]
    assert_equal traveller.start_location, res[:travel_info][:location]
  end

  test 'other characters travelling nearby' do
    create(:traveller, subject: @character)
    @character.update!(location: nil, coords: { x: 100, y: 100 })
    nearby_char = create(:character, location: nil, coords: { x: 103, y: 100 })
    distant_char = create(:character, location: nil, coords: { x: 103.01, y: 100 })
    create(:traveller, subject: nearby_char)
    create(:traveller, subject: distant_char)

    res = call_service

    assert_equal [@character.id, nearby_char.id].sort, res[:characters].pluck(:id).sort
  end

  test 'show create_location project after starting' do
    @character.update!(location: nil, coords: { x: 100, y: 100 })
    project = create(:project, :create_location, starting_character: @character)

    res = call_service

    assert_equal [project.id], res[:projects].pluck(:id)
  end

  test 'show projects from nearby character' do
    @character.update!(location: nil, coords: { x: 100, y: 100 })
    near_character = create(:character, location: nil, coords: { x: 100, y: 101 })
    far_character = create(:character, location: nil, coords: { x: 105, y: 101 })
    project = create(:project, :create_location, starting_character: near_character)
    create(:project, :create_location, starting_character: far_character)

    res = call_service

    assert_equal 1, res[:projects].length
    assert_equal [project.id], res[:projects].pluck(:id)
  end

  test 'show roads (exits)' do
    @character.location.update!(coords: { x: 100, y: 100 })
    unnamed_location = create(:location, coords: { x: 50, y: 100 }) # west
    named_location = create(:location, coords: { x: 100, y: 50 }) # north
    create(:location_name, character: @character, location: named_location,
                           name: 'Someplace')
    create(:road, location_1: @character.location,
                  location_2: unnamed_location)
    create(:road, location_1: named_location,
                  location_2: @character.location)

    res = call_service

    assert_equal 2, res[:roads].length

    r = res[:roads].first
    assert_equal %i[direction id location_id location_name type], r.keys.sort

    named = res[:roads].find { |r| r[:location_id] == named_location.id }
    assert_equal 'Someplace', named[:location_name]
    assert_equal 'path', named[:type]
    assert_equal 'north', named[:direction]

    unnamed = res[:roads].find { |r| r[:location_id] == unnamed_location.id }
    assert_equal 'unnamed place', unnamed[:location_name]
    assert_equal 'path', unnamed[:type]
    assert_equal 'west', unnamed[:direction]
  end

  test 'show vehicles in location' do
    create(:location, :vehicle, parent_location: @character.location)

    res = call_service

    assert_equal 1, res[:vehicles].length
  end

  test 'show exits when character in vehicle in location' do
    main_location = @character.location
    cart = create(:location, :vehicle, parent_location: @character.location)
    main_location.update(coords: { x: 100, y: 100 })
    @character.update!(location: cart, coords: { x: 100, y: 100 })
    unnamed_location = create(:location, coords: { x: 50, y: 100 }) # west
    named_location = create(:location, coords: { x: 100, y: 50 }) # north
    create(:location_name, character: @character, location: named_location,
                           name: 'Someplace')
    create(:road, location_1: main_location,
                  location_2: unnamed_location)
    create(:road, location_1: named_location,
                  location_2: main_location)

    res = call_service

    assert_equal 2, res[:roads].length
  end
end
