# frozen_string_literal: true

require 'test_helper'

class TravellersUpdateServiceTest < ActiveSupport::TestCase
  def setup
    # @location = create(:location, coords: { x: 100, y: 150 })
    @character = create(:character, location: @location, coords: nil)
  end

  def call_service(params)
    Travellers::UpdateService.call(@character, params)
  end

  test 'create new traveller record' do
    traveller = create(:traveller, subject: @character)

    params = {
      id: traveller.id,
      speed: 35,
      direction: 90
    }

    assert_difference -> { Traveller.count } => 0,
                      -> { Event.count } => 1 do
      call_service(params)
    end

    assert_equal params[:speed], traveller.reload.speed
    assert_equal params[:direction], traveller.direction

    ev = Event.last
    assert_equal "You're updating travel settings",
                 ev.body
  end
end
