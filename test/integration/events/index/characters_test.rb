# frozen_string_literal: true

require 'test_helper'

class EventsIndexCharactersTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
  end

  test 'not logged in user' do
    visit events_url

    assert_text 'Fabular login'
  end

  test 'logged in user without character set' do
    sign_in
    visit events_url

    assert_text 'user@me.com'
  end

  test 'signed-in user with some characters' do
    fabular_city = create(:location, name: 'Fabular City')
    other_city = create(:location, name: 'Other City')
    magnus = create(:character, name: 'Magnus', location: fabular_city, user: @user)
    create(:character, name: 'Ella', gender: 'K', location: fabular_city, user: @user)
    create(:character, name: 'Sid', location: other_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content('Events for: Magnus')
    assert_content('Location:')
    assert_content('unnamed place')
    assert_link('Magnus', href: "#{host}/en/characters/#{magnus.id}")
    assert_link('unknown woman')
    assert_no_link('Sid')
    assert_content('Resources')
    assert_content('Items')
    assert_content('Projects')
    assert_link('Discover new resource',
                href: "#{host}/en/location_resources")
    assert_link('Build menu', href: "#{host}/en/recipes")
    assert_link('Inventory', href: "#{host}/en/inventory_objects")
    assert_selector 'section#map'
    assert_no_content 'Borders a sea'
    assert_no_content 'Borders a lake'
    assert_link 'Write a note', href: "#{host}/en/notes/new"
  end

  test 'show characters in main location by a character in a vehicle' do
    fabular_city = create(:location, name: 'Fabular City')
    vehicle = create(:location, :vehicle, parent_location: fabular_city)
    create(:character, name: 'Magnus', location: vehicle, user: @user)
    town_character = create(:character, location: fabular_city, gender: 'K')

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'unknown woman (unnamed place)'
    assert_link 'unknown woman', href: "#{host}/en/characters/#{town_character.id}/name"
  end

  test "don't show characters in main location by a character in a building" do
    fabular_city = create(:location, name: 'Fabular City')
    building = create(:location, :building, parent_location: fabular_city)
    create(:character, name: 'Magnus', location: building, user: @user)
    town_character = create(:character, location: fabular_city, gender: 'K')

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_no_link 'unknown woman', href: "#{host}/en/characters/#{town_character.id}/name"
  end

  test 'show characters in vehicles' do
    fabular_city = create(:location, name: 'Fabular City')
    vehicle = create(:location, :vehicle, parent_location: fabular_city, name: 'Turtle')
    create(:character, name: 'Magnus', location: fabular_city, gender: 'M', user: @user)
    create(:character, location: vehicle, gender: 'K')

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'unknown woman (Turtle [small wooden cart])'
  end
end
