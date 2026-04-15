# frozen_string_literal: true

require 'test_helper'

class EventsShowServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    Events::ShowService.call(@character)
  end

  test 'characters info' do
    other_char = create(:character, location: @character.location)

    res = call_service

    assert_equal [@character.id, other_char.id].sort, res[:characters].pluck(:id).sort
  end
  test 'travel info' do
    traveller = create(:traveller, subject: @character)
    @character.update!(location: nil, coords: { x: 100, y: 100 })

    res = call_service

    assert_equal [@character], res[:characters]
    assert_equal traveller.speed, res[:travel_info][:speed]
    assert_equal traveller.direction, res[:travel_info][:direction]
    assert_equal traveller.id, res[:travel_info][:traveller_id]
    assert_equal traveller.start_location, res[:travel_info][:location]
  end

  test 'other characters travelling nearby' do
    create(:traveller, subject: @character)
    @character.update!(location: nil, coords: { x: 100, y: 100 })
    nearby_char = create(:character, location: nil, coords: { x: 103, y: 100 })
    distant_char = create(:character, location: nil, coords: { x: 103.01, y: 100 })
    create(:traveller, subject: nearby_char)
    create(:traveller, subject: distant_char)

    res = call_service

    assert_equal [@character.id, nearby_char.id].sort, res[:characters].pluck(:id).sort
  end
end
