# frozen_string_literal: true

require 'test_helper'

class LocationsUndockTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
    @location = create(:location)
  end

  test 'raise error when character not on ship 1' do
    character = create(:character, location: @location, user: @user, name: 'Magnus')

    login(@user, character)

    get "/en/locations/#{@location.id}/undock"

    assert_response :found
    assert_redirected_to '/en/events'
  end

  test 'raise error when character not on ship 2' do
    ship = create(:location, :ship, parent_location: @location)
    character = create(:character, location: @location, user: @user, name: 'Magnus')

    login(@user, character)

    get "/en/locations/#{ship.id}/undock"

    assert_response :found
    assert_redirected_to '/en/events'
  end

  test 'raise error when character on another ship' do
    ship_1 = create(:location, :ship, parent_location: @location)
    ship_2 = create(:location, :ship, parent_location: @location)
    character = create(:character, location: ship_1, user: @user, name: 'Magnus')

    login(@user, character)

    get "/en/locations/#{ship_2.id}/undock"

    assert_response :found
    assert_redirected_to '/en/events'
  end

  test 'shows undock page' do
    ship = create(:location, :ship, parent_location: @location)
    create(:character, location: ship, user: @user, name: 'Magnus')
    Locations::UndockInfoService.any_instance.expects(:call)
                                .returns({ directions: %w[nw w] })

    sign_in(@user)

    click_on 'Magnus'

    assert_link 'Undock'

    click_on 'Undock'

    assert_equal 200, page.status_code

    assert_no_link 'Undock'
    assert_content 'Choose a direction in which you want to undock:'
    assert_selector "form[action='#{host}/en/ship_actions']"
    assert_selector 'label', text: 'west'
    assert_selector 'label', text: 'north-west'
  end
end
