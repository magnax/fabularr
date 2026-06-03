# frozen_string_literal: true

require 'test_helper'

class Locations::EnterLocationServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(location_id)
    Locations::EnterLocationService.call(@character, location_id)
  end

  test 'enter the building from town location' do
    location = create(:location) # default is town
    building = create(:location, :building, parent_location: location, name: nil)
    @character.update!(location: location)

    assert_difference -> { Event.count } => 1 do
      call_service(building.id)
    end

    char_events = Event.where(receiver_character: @character)
    assert_includes char_events.pluck(:body),
                    'You are entering from '\
                    "<!--LOCID:#{location.id}-->"\
                    ' into '\
                    "<!--LOCID:#{building.id}-->"\
                    ', where you see 0 people'
  end

  test 'enter the building from town location - other characters present' do
    location = create(:location) # default is town
    building = create(:location, :building, parent_location: location, name: 'Town Hall')
    @character.update!(location: location)

    town_character = create(:character, location: location)
    building_character = create(:character, location: building)

    assert_difference -> { Event.count } => 3 do
      call_service(building.id)
    end

    char_events = Event.where(receiver_character: @character)
    assert_includes char_events.pluck(:body),
                    'You are entering from '\
                    "<!--LOCID:#{location.id}-->"\
                    ' into ' \
                    "<!--LOCID:#{building.id}-->"\
                    ', where you see 1 people'

    ev = Event.where(receiver_character: town_character).sole
    assert_equal 'You see '\
                 "<!--CHARID:#{@character.id}--> "\
                 'is leaving '\
                 "<!--LOCID:#{location.id}-->"\
                 ' entering '\
                 "<!--LOCID:#{building.id}-->",
                 ev.body

    ev = Event.where(receiver_character: building_character).sole
    assert_equal 'You see '\
                 "<!--CHARID:#{@character.id}--> "\
                 'is entering '\
                 "<!--LOCID:#{building.id}-->"\
                 ' from '\
                 "<!--LOCID:#{location.id}-->",
                 ev.body
  end

  test 'raises an error when max characters exceeded' do
    location = create(:location) # default is town
    building = create(:location, :building, parent_location: location,
                                            name: 'Town Hall', max_characters: 1)
    @character.update!(location: location)

    create(:character, location: building)

    assert_raises Locations::EnterLocationService::MaxCharactersExceededError do
      call_service(building.id)
    end
  end

  test 'raises an error when max capacity exceeded' do
    location = create(:location) # default is town
    building = create(:location, :building, parent_location: location,
                                            name: 'Town Hall', max_capacity: 100_000)
    @character.update!(location: location)

    stone = create(:resource, key: 'stone')
    create(:location_object, location: building, subject: stone, amount: 30_000)
    create(:inventory_object, character: @character, subject: stone, amount: 11_000)

    assert_raises Locations::EnterLocationService::MaxCapacityExceededError do
      call_service(building.id)
    end
  end
end
