require 'test_helper'

class Locations::CreateSpawnEventsTest < ActiveSupport::TestCase
  def call_service(location, character)
    Locations::CreateSpawnEvents.call(location, character)
  end

  test 'creates proper location type event' do
    # create_list(:character, 3, location: @location)
    forest_type = create(:location_type, key: 'forest')
    location = create(:location, location_type: forest_type)
    character = create(:character, spawn_location: location, location: location)

    call_service(location, character)

    char_events = Event.where(receiver_character: character)
    assert_includes char_events.pluck(:body), 'You are in some place which looks like forest.'
  end
end
