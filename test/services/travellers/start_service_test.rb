# frozen_string_literal: true

require 'test_helper'

class TravellersStartServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location, coords: { x: 100, y: 150 })
    @character = create(:character, location: @location, coords: nil)
  end

  def call_service(params)
    Travellers::StartService.call(@character, params)
  end

  test 'create new traveller record' do
    params = {
      direction: 90
    }

    assert_difference -> { Traveller.count } => 1,
                      -> { Event.count } => 1 do
      call_service(params)
    end

    t = Traveller.last
    assert_equal @character, t.subject
    assert_equal params[:direction], t.direction

    assert_equal 100, @character.reload.x
    assert_equal 150, @character.y
    assert_nil @character.location_id
    assert @character.travelling?

    assert_equal 1, Traveller.active.count

    ev = Event.last
    assert_equal "You're leaving "\
                 "<!--LOCID:#{@location.id}-->"\
                 ' heading in direction: 90',
                 ev.body
  end

  test 'create new traveller record when taking a road' do
    @location.update!(coords: { x: 314, y: 518 })
    other_location = create(:location, coords: { x: 283, y: 563 })
    road = create(:road, location_1: @location, location_2: other_location)

    params = {
      road_id: road.id
    }

    assert_difference -> { Traveller.count } => 1,
                      -> { Event.count } => 1 do
      call_service(params)
    end

    t = Traveller.last
    assert_equal @character, t.subject
    assert_equal 214.56, t.direction.round(2)
    assert_equal road.id, t.road_id

    assert_equal 314, @character.reload.x
    assert_equal 518, @character.y
    assert_nil @character.location_id
    assert @character.travelling?

    assert_equal 1, Traveller.active.count

    ev = Event.last
    assert_equal "You're leaving "\
                 "<!--LOCID:#{@location.id}-->"\
                 ' taking path to '\
                 "<!--LOCID:#{other_location.id}-->",
                 ev.body
  end

  test 'create new traveller record when taking a road (in vehicle)' do
    @location.update!(coords: { x: 100, y: 100 })
    other_location = create(:location, coords: { x: 150, y: 100 })
    road = create(:road, location_1: @location, location_2: other_location)
    cart = create(:location, :vehicle, parent_location: @location)
    @character.update!(location: cart)

    params = {
      road_id: road.id
    }

    assert_difference -> { Traveller.count } => 1,
                      -> { Event.count } => 1 do
      call_service(params)
    end

    t = Traveller.last
    assert_equal cart, t.subject
    assert_equal 90, t.direction.round(2)
    assert_equal road.id, t.road_id

    assert_equal 100, cart.reload.x
    assert_equal 100, cart.y
    assert_nil cart.parent_location_id
    assert_equal cart.id, @character.reload.location_id
    assert @character.travelling?

    assert_equal 1, Traveller.active.count

    ev = Event.last
    assert_equal "You're leaving "\
                 "<!--LOCID:#{@location.id}-->"\
                 ' taking path to '\
                 "<!--LOCID:#{other_location.id}-->"\
                 ', using '\
                 "<!--LOCID:#{cart.id}-->",
                 ev.body
  end
end
