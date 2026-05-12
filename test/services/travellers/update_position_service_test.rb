# frozen_string_literal: true

require 'test_helper'

class TravellersUpdatePositionServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character, location: nil, coords: { x: 100, y: 100 })
    @time = DateTime.parse('2026-02-01 11:00:00')
  end

  def teardown
    Timecop.unfreeze
  end

  def call_service(traveller)
    Travellers::UpdatePositionService.call(traveller)
  end

  directions = [
    { dir: 0, text: 'north (up)',
      exp_x: 100, exp_y: 94.792 },
    { dir: 45, text: 'north-east (up right)',
      exp_x: 103.6826, exp_y: 96.3174 },
    { dir: 90, text: 'east (right)',
      exp_x: 105.208, exp_y: 100 },
    { dir: 135, text: 'south-east (down right)',
      exp_x: 103.6826, exp_y: 103.6826 },
    { dir: 180, text: 'south (down)',
      exp_x: 100, exp_y: 105.208 },
    { dir: 225, text: 'south-west (down left)',
      exp_x: 96.3174, exp_y: 103.6826 },
    { dir: 270, text: 'west (left)',
      exp_x: 94.792, exp_y: 100 },
    { dir: 315, text: 'north-west (up left)',
      exp_x: 96.3174, exp_y: 96.3174 }
  ]

  directions.each do |test_data|
    test "simple update - #{test_data[:text]}" do
      mock_maps
      Timecop.freeze(@time)
      traveller = create(:traveller, subject: @character, speed: 100,
                                     direction: test_data[:dir])

      Timecop.freeze(@time + 100.minutes)
      call_service(traveller)

      assert_equal test_data[:exp_x], @character.reload.x.round(4)
      assert_equal test_data[:exp_y], @character.y.round(4)
      assert_equal @time + 100.minutes, traveller.reload.checked_at
    end
  end

  test 'simple update - direction > 360' do
    mock_maps
    Timecop.freeze(@time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 675) # == 315

    Timecop.freeze(@time + 100.minutes)
    call_service(traveller)

    assert_equal 96.3174, @character.reload.x.round(4)
    assert_equal 96.3174, @character.y.round(4)
    assert_equal @time + 100.minutes, traveller.reload.checked_at
  end

  test 'stop travel when arriving at no habitable type of land' do
    create(:location_type, key: 'beach')
    @character.update!(location: nil, coords: { x: 500, y: 170 })
    Timecop.freeze(@time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 0)
    assert_equal 'beach', Maps.location_type(traveller.subject.x, traveller.subject.y).key
    Timecop.freeze(@time + 100.minutes)
    assert_difference -> { Event.count } => 1 do
      call_service(traveller)
    end

    assert_equal 500, @character.reload.x.round(4)
    assert_equal 'beach', Maps.location_type(
      traveller.subject.x, traveller.subject.y
    ).key

    assert_equal 166, @character.y.round(4)

    assert_equal @time + 100.minutes, traveller.reload.checked_at
    assert_equal 0, traveller.speed
    ev = Event.last
    assert_equal 'You stopped, because there is no possible to go further in that direction', ev.body
  end

  test 'simplest update (straight up north) in vehicle' do
    mock_maps
    cart = create(:location, :vehicle, parent_location: nil, coords: { x: 100, y: 100 })
    @character.update!(location: cart)
    Timecop.freeze(@time)
    traveller = create(:traveller, subject: cart, speed: 100, direction: 0)

    Timecop.freeze(@time + 100.minutes)
    call_service(traveller)

    assert_equal 100, cart.reload.x.round(4)
    assert_equal 94.792, cart.y.round(4)
    assert_equal @time + 100.minutes, traveller.reload.checked_at
  end

  test 'arriving at location in vehicle' do
    mock_maps
    character = create(:character, location: nil)
    location_1 = create(:location, coords: { x: 200, y: 200 })
    location_2 = create(:location, coords: { x: 200, y: 100 })
    road = create(:road, location_1: location_1, location_2: location_2)
    create(:traveller, subject: character, start_location: location_1,
                       direction: 180, speed: 100, road: road, checked_at: time)
    cart = create(:location, :vehicle, parent_location: nil, coords: { x: 200, y: 101 })
    @character.update!(location: cart)
    Timecop.freeze(@time)
    traveller = create(:traveller, start_location: location_1,
                                   subject: cart, speed: 100, road: road)

    Timecop.freeze(@time + 300.minutes)

    assert_difference -> { Event.count } => 1 do
      call_service(traveller)
    end

    assert_not @character.reload.travelling?
    assert_equal location_2, cart.reload.parent_location
    assert_equal cart, @character.location
    assert_not traveller.reload.status

    event = Event.last
    assert_equal "You arrived at <!--LOCID:#{location_2.id}-->", event.body
  end

  test 'arrive to location in free travel when location is on the way' do
    mock_maps
    character = create(:character, location: nil, coords: { x: 200, y: 101.1 })
    town = create(:location, coords: { x: 200, y: 100 })

    Timecop.freeze(@time)
    traveller = create(:traveller, subject: character, speed: 100, direction: 0)

    Timecop.freeze(@time + 10.minutes)
    call_service(traveller)

    assert_equal town, character.reload.location
    assert_not character.travelling?

    event = Event.last
    assert_equal "You arrived at <!--LOCID:#{town.id}-->", event.body
  end

  test 'different speeds for character depending on load' do
    mock_maps(10)
    wood = create(:resource, key: 'wood')
    character_1 = create(:character, location: nil, coords: { x: 200, y: 100 })
    character_2 = create(:character, location: nil, coords: { x: 200, y: 100 })
    character_3 = create(:character, location: nil, coords: { x: 200, y: 100 })

    # very minimal load for character_1:
    create(:inventory_object, subject: wood, character: character_1, amount: 1499)
    # just under half load for character_2:
    create(:inventory_object, subject: wood, character: character_2, amount: 7499)
    # max load for character_1:
    create(:inventory_object, subject: wood, character: character_3, amount: 15_000)
    Timecop.freeze(@time)
    create(:traveller, subject: character_1, speed: 100, direction: 0)
    create(:traveller, subject: character_2, speed: 100, direction: 0)
    create(:traveller, subject: character_3, speed: 100, direction: 0)

    Timecop.freeze(@time + 50.minutes)

    [character_1, character_2, character_3].each do |character|
      call_service(character.traveller)
      assert_equal @time + 50.minutes, character.traveller.reload.checked_at
      assert_equal 200, character.reload.x.round(4)
    end

    assert_equal 97.396, character_1.y.round(4)
    assert_equal 98.264, character_2.y.round(4)
    assert_equal 99.132, character_3.y.round(4)
  end
end
