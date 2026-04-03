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
                    'You are entering from Fabular City into Wood shack, where you see 0 people'
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
                    'You are entering from Fabular City into Town Hall, where you see 1 people'

    ev = Event.where(receiver_character: town_character).sole
    assert_equal "You see <!--CHARID:#{@character.id}--> is leaving Fabular City entering Town Hall",
                 ev.body

    ev = Event.where(receiver_character: building_character).sole
    assert_equal "You see <!--CHARID:#{@character.id}--> is entering Town Hall from Fabular City",
                 ev.body
  end
end
