# frozen_string_literal: true

require 'test_helper'

class ShipActionsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location, coords: { x: 200, y: 200 })
    @user = create(:user)
    @character = create(:character, location: @location, name: 'Magnus', user: @user)
  end

  test 'raise error when not on ship' do
    login(@character.user, @character)

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

    login(@character.user, @character)

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

    traveller = Traveller.last
    assert_equal 0, traveller.speed
  end

  test 'undock and float on the sea - proper page content' do
    ship = create(:location, :ship, parent_location: @location, name: 'Vinterriket')
    @character.update!(location: ship)
    Maps.expects(:location_type).with(anything, anything).times(9).returns('water')

    sign_in(@user)

    click_on 'Magnus'

    visit "/en/locations/#{ship.id}/undock"
    choose 'ship_action_direction_n'
    click_on 'Undock'

    assert_no_link 'Undock'
    assert_content 'This ship is currently floating on the water.'
    assert_content 'Vinterriket - [sloop]'

    id = @character.reload.traveller.id
    assert_selector "form[action='#{host}/en/travellers/#{id}']"
  end
end
