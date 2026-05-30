# frozen_string_literal: true

require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    sign_in
  end

  test 'visiting the characters list page' do
    visit list_url
    assert_selector 'h1', text: "Hello #{@user.email}"
  end

  test 'proper gender info for character' do
    create(:character, user: @user, gender: 'M')

    visit list_url

    assert_selector 'i.fa-mars'
  end

  test 'proper location type info for character' do
    create(:character, user: @user)

    visit '/pl/list'

    assert_content 'las'
  end

  test 'proper location type info when in building (parent type)' do
    location = create(:location)
    building = create(:location, :building, parent_location: location)
    character = create(:character, user: @user, location: building)
    create(:location_name, location: location, character: character, name: 'Fabular City')

    visit '/pl/list'

    assert_content 'Drewniana chata'
    assert_content 'las'
  end

  test 'show admin menu when logged as admin' do
    @user.update!(god: true)

    visit list_url

    assert_link 'Admin', href: "#{host}/admin?locale=en"
  end

  test 'character travelling freely' do
    character = create(:character, :travelling, user: @user)
    create(:location_name, location: character.spawn_location,
                           character: character, name: 'Fabular City')
    create(:traveller, subject: character,
                       start_location: character.spawn_location,
                       road: nil, direction: 315)

    visit list_url

    assert_equal 200, page.status_code
    assert_content 'Travelling from Fabular City (north-east)'
  end

  test 'character travelling on road' do
    character = create(:character, :travelling, user: @user)
    dest_location = create(:location, coords: { x: 150, y: 150 })
    create(:location_name, location: character.spawn_location,
                           character: character, name: 'Fabular City')
    create(:location_name, location: dest_location,
                           character: character, name: 'Other City')
    road = create(:road, location_1: dest_location, location_2: character.spawn_location)
    create(:traveller, subject: character,
                       start_location: character.spawn_location,
                       road: road, direction: 45)

    visit list_url

    assert_equal 200, page.status_code
    assert_content 'Travelling from Fabular City to Other City'
    assert_content '(T 0%)'
  end

  test 'character travelling in vehicle' do
    cart = create(:location, :vehicle, parent_location: nil)
    character = create(:character, location: cart, user: @user)
    dest_location = create(:location, coords: { x: 150, y: 150 })
    create(:location_name, location: character.spawn_location,
                           character: character, name: 'Fabular City')
    create(:location_name, location: dest_location,
                           character: character, name: 'Other City')
    road = create(:road, location_1: dest_location, location_2: character.spawn_location)
    create(:traveller, subject: cart,
                       start_location: character.spawn_location,
                       road: road, direction: 45)

    visit list_url

    assert_equal 200, page.status_code
    assert_content 'Travelling from Fabular City to Other City'
    assert_content '(T 0%)'
  end
end
