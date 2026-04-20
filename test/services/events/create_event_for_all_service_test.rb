# frozen_string_literal: true

require 'test_helper'

class EventsCreateEventForAllServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  def call_service(characters, body)
    Events::CreateEventForAllService.call(characters, body)
  end

  test 'create events for characters in the same location' do
    location = create(:location)
    char_1 = create(:character, location: location)
    char_2 = create(:character, location: location)

    assert_difference -> { Event.count } => 2 do
      call_service([char_1, char_2], 'new event!')
    end

    assert_broadcast_on "location_#{location.id}", { type: 'event', body: 'new event!' }
  end

  test 'create events for travelling characters' do
    char_1 = create(:character, location: nil)
    char_2 = create(:character, location: nil)

    assert_difference -> { Event.count } => 2 do
      call_service([char_1, char_2], 'new event')
    end

    [char_1.id, char_2.id].each do |id|
      assert_broadcast_on "char_#{id}", { type: 'event', body: 'new event' }
    end
  end
end
