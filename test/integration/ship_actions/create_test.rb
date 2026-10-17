# frozen_string_literal: true

require 'test_helper'

class ShipActionsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location, coords: { x: 200, y: 200 })
    @character = create(:character, location: @location, name: 'Magnus')
    login(@character.user, @character)
  end

  test 'raise error when not on ship' do
    params = {
      ship_action: {
        direction: 'nw'
      }
    }

    assert_difference -> { Traveller.count } => 0 do
      post '/ship_actions', params: params
    end

    assert_response :found
    assert_redirected_to events_path
  end

  test 'undock and float on the sea' do
    ship = create(:location, :ship, parent_location: @location)
    @character.update!(location: ship)
    Maps.expects(:location_type).with(200, 180).returns('water')

    params = {
      ship_action: {
        direction: 'n'
      }
    }

    assert_difference -> { Traveller.count } => 1 do
      post '/ship_actions', params: params
    end

    assert_response :found
    assert_redirected_to events_path
  end
end
