# frozen_string_literal: true

require 'test_helper'

class EventsShowServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service
    Events::ShowService.call(@character)
  end

  test 'travel info' do
    traveller = create(:traveller, subject: @character)

    res = call_service

    assert_equal traveller.speed, res[:travel_info][:speed]
    assert_equal traveller.direction, res[:travel_info][:direction]
    assert_equal traveller.id, res[:travel_info][:traveller_id]
    assert_equal traveller.start_location, res[:travel_info][:location]
  end
end
