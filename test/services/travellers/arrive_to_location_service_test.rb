# frozen_string_literal: true

require 'test_helper'

class TravellersArriveToLocationServiceTest < ActiveSupport::TestCase
  def call_service(traveller)
    Travellers::ArriveToLocationService.call(traveller)
  end

  test 'several people, travelling in vehicle' do
    vehicle = create(:location, :vehicle)
    vehicle_character_1 = create(:character, location: vehicle)
    vehicle_character_2 = create(:character, location: vehicle)
    town = create(:location)
    start_location = create(:location)
    building = create(:location, :building, parent_location: town)
    town_character = create(:character, location: town)
    building_character = create(:character, location: building)

    road = create(:road, location_1: town, location_2: start_location)
    traveller = create(:traveller, subject: vehicle, road: road, start_location: start_location)

    assert vehicle_character_1.reload.travelling?
    assert vehicle_character_2.reload.travelling?

    assert_difference -> { Event.count } => 3 do
      call_service(traveller)
    end

    body = "You arrived at <!--LOCID:#{town.id}-->"

    event = Event.where(receiver_character: vehicle_character_1).sole
    assert_equal body, event.body

    event = Event.where(receiver_character: vehicle_character_2).sole
    assert_equal body, event.body

    event = Event.where(receiver_character: town_character).sole
    assert_equal "You see that <!--LOCID:#{vehicle.id}-->"\
                 " is arriving from <!--LOCID:#{start_location.id}-->",
                 event.body

    assert_equal 0, Event.where(receiver_character: building_character).count

    assert_equal town.id, vehicle.reload.parent_location_id
    assert_not vehicle_character_1.reload.travelling?
    assert_not vehicle_character_2.reload.travelling?
    assert_not traveller.reload.status
  end
end
