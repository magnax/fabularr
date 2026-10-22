# frozen_string_literal: true

require 'test_helper'

class EventsIndexShipsTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
  end

  test 'names and links to ships' do
    fabular_city = create(:location, name: 'Fabular City')
    sloop = create(:location, :ship, parent_location: fabular_city, name: 'My Ship')

    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'My Ship (sloop)'
    assert_link nil, title: 'Enter this ship',
                     href: "#{host}/en/locations/#{sloop.id}/enter"
  end

  test 'show "undock" option when character in ship' do
    fabular_city = create(:location)
    sloop = create(:location, :ship, parent_location: fabular_city, name: 'My Ship')

    character = create(:character, name: 'Magnus', location: sloop, user: @user)
    create(:location_name, location: fabular_city, character: character,
                           name: 'Fabular City')

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'Fabular City (My Ship) - [sloop]'
    assert_link 'Undock', href: "#{host}/en/locations/#{sloop.id}/undock"
  end

  test 'show direction and speed when ship is moving' do
    sloop = create(:ship, name: 'My Ship')
    create(:character, name: 'Magnus', location: sloop, user: @user)
    create(:traveller, subject: sloop, direction: 200, speed: 80)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'My Ship - [sloop]'
    assert_content 'This ship is currently sailing in the direction 200 with 80 percent speed'
  end
end
