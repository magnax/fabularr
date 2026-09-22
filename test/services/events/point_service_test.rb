# frozen_string_literal: true

require 'test_helper'

class EventsPointServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(params)
    Events::PointService.call(@character, params)
  end

  test 'point - raise error when invalid subject' do
    params = {
      id: @character.location.id,
      type: 'location'
    }

    assert_raises Events::InvalidPointObjectError do
      call_service(params)
    end
  end

  test 'point person - raise error when invalid character' do
    params = {
      id: 0,
      type: 'character'
    }

    assert_raises Events::InvalidPointObjectError do
      call_service(params)
    end
  end

  test 'point person - raise error when character not visible' do
    building = create(:location, :building, parent_location: @location)
    other_character = create(:character, location: building)

    params = {
      id: other_character.id,
      type: 'character'
    }

    assert_raises Events::InvalidPointObjectError do
      call_service(params)
    end
  end

  test 'point person' do
    other_character = create(:character, location: @location)
    third_character = create(:character, location: @location)

    params = {
      id: other_character.id,
      type: 'character'
    }

    assert_difference -> { Event.count } => 3 do
      call_service(params)
    end

    event = Event.where(receiver_character: @character).sole
    assert_equal "You point at <!--CHARID:#{other_character.id}-->",
                 event.body

    event = Event.where(receiver_character: other_character).sole
    assert_equal "You see <!--CHARID:#{@character.id}--> pointing at you",
                 event.body

    event = Event.where(receiver_character: third_character).sole
    assert_equal "You see <!--CHARID:#{@character.id}-->"\
                 " pointing at <!--CHARID:#{other_character.id}-->",
                 event.body
  end

  test 'point road' do
    other_location = create(:location)
    road = create(:road, location_1: @location, location_2: other_location)
    other_character = create(:character, location: @location)

    params = {
      id: road.id,
      type: 'road'
    }

    assert_difference -> { Event.count } => 2 do
      call_service(params)
    end

    event = Event.where(receiver_character: @character).sole
    assert_equal "You point at road: path to <!--LOCID:#{other_location.id}-->",
                 event.body

    event = Event.where(receiver_character: other_character).sole
    assert_equal "You see <!--CHARID:#{@character.id}-->"\
                 " pointing at road: path to <!--LOCID:#{other_location.id}-->",
                 event.body
  end
end
