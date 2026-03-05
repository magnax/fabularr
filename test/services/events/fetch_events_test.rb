# frozen_string_literal: true

require 'test_helper'

class Events::FetchEventsTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    existing_character = create(:character, location: @location,
                                            spawn_location: @location)
    create(:event, location: @location, character: existing_character,
                   body: 'Hello!')
  end

  def call_service(character)
    Events::FetchEvents.call(character)
  end

  test 'new character - fetch only events created after spawning' do
    character = create(:character, location: @location, spawn_location: @location)

    result = call_service(character)

    assert_empty result
  end
end
