# frozen_string_literal: true

require 'test_helper'

class Characters::CreateInitialEventsTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
  end

  def call_service(character)
    Characters::CreateInitialEvents.call(character)
  end

  test 'creates event with proper number of other characters in location: none' do
    character = create(:character, spawn_location: @location, location: @location)

    assert_difference -> { Event.count }, 3 do
      call_service(character)
    end

    char_events = Event.where(receiver_character: character)
    assert_equal 3, char_events.length
    assert_includes char_events.pluck(:body), 'You don\'t see anyone nearby.'
  end

  test 'creates event with proper number of other characters in location: one' do
    create(:character, location: @location)
    character = create(:character, spawn_location: @location, location: @location)

    assert_difference -> { Event.count }, 4 do
      call_service(character)
    end

    char_events = Event.where(receiver_character: character)
    assert_equal 3, char_events.length
    assert_includes char_events.pluck(:body), 'You see one other person nearby.'
  end

  test 'creates event with proper number of other characters in location: many' do
    create_list(:character, 3, location: @location)
    character = create(:character, spawn_location: @location, location: @location)

    assert_difference -> { Event.count }, 6 do
      call_service(character)
    end

    char_events = Event.where(receiver_character: character)
    assert_equal 3, char_events.length
    assert_includes char_events.pluck(:body), 'You see 3 other people nearby.'
  end
end
