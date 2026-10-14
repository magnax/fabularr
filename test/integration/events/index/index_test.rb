# frozen_string_literal: true

require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
  end

  test 'link to collect resource on events page (visible only)' do
    fabular_city = create(:location, name: 'Fabular City')
    mushrooms = create(:location_resource, location: fabular_city, status: true,
                                           resource: create(:resource, key: 'mushrooms'))
    stone = create(:location_resource, location: fabular_city, status: false,
                                       resource: create(:resource, key: 'stone'))
    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content('mushrooms')
    assert_link(
      'Collect', href: "#{host}/en/new/projects/collect/#{mushrooms.id}"
    )
    assert_no_link(
      'Collect', href: "#{host}/en/new/projects/collect/#{stone.id}"
    )
  end

  test 'resources and items are visible' do
    fabular_city = create(:location, name: 'Fabular City')
    lr = create(:location_object, location: fabular_city,
                                  subject: create(:resource, key: 'mushrooms'),
                                  amount: 200, unit: 'grams')
    create(:character, name: 'Magnus', location: fabular_city, user: @user)
    stone_knife = create(:item_type, key: 'stone_knife', weight: 120)
    knife = create(:item, item_type: stone_knife)
    location_knife = create(:location_object, location: fabular_city,
                                              subject: knife, unit: nil)
    note = create(:note)
    location_note = create(:location_object, location: fabular_city,
                                             subject: note)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content '200 grams mushrooms'
    assert_link 'Take', href: "#{host}/en/location_objects/#{lr.id}/take"
    assert_content 'brand new stone knife'
    assert_link 'Take', href: "#{host}/en/location_objects/#{location_knife.id}/take_item"
    assert_content "note - \"#{note.title}\""
    assert_link 'Take', href: "#{host}/en/location_objects/#{location_note.id}/take_item"
    assert_link nil, href: "#{host}/en/notes/#{note.id}/copy", title: 'Copy this note'
  end

  test 'links to location names' do
    fabular_city = create(:location, name: 'Fabular City')
    town_hall = create(:location, :building, parent_location: fabular_city, name: 'Town Hall')

    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_link 'unnamed place', href: "#{host}/en/locations/#{fabular_city.id}/name"
    assert_link 'Town Hall', href: "#{host}/en/locations/#{town_hall.id}/name"
  end

  test 'show road building link' do
    fabular_city = create(:location, name: 'Fabular City')
    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_link 'Build a road', href: "#{host}/en/new/projects/road/#{fabular_city.id}"
  end

  test 'show exit and link to start travel on the road' do
    fabular_city = create(:location, name: 'Fabular City')
    other_location = create(:location)
    create(:road, location_1: fabular_city, location_2: other_location)
    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'path to unnamed place'
  end

  test 'do not show travel related links when creating new location' do
    character = create(:character, name: 'Magnus', location: nil, user: @user,
                                   coords: { x: 100, y: 100 })
    project = create(:project, :create_location, location: nil,
                                                 elapsed: 300, duration: 600)
    create(:traveller, subject: character, speed: 0)
    create(:worker, character: character, project: project)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'Project:'
    assert_content 'Creating new location 50.0%'
    assert_no_link 'Examine location'
    assert_no_link 'Reverse'
  end

  test 'links to various things that can be pointed' do
    fabular_city = create(:location, name: 'Fabular City')
    other_location = create(:location)
    road = create(:road, location_1: fabular_city, location_2: other_location)
    create(:character, name: 'Magnus', location: fabular_city, user: @user)
    other_character = create(:character, location: fabular_city)
    project = create(:project, location: fabular_city, elapsed: 0, duration: 100)
    note = create(:note)
    create(:location_object, location: fabular_city, subject: note)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_link(nil, title: 'Point at this person',
                     href: "#{host}/en/point/character/#{other_character.id}")
    assert_link(nil, title: 'Point at this road',
                     href: "#{host}/en/point/road/#{road.id}")
    assert_link(nil, title: 'Point at this project',
                     href: "#{host}/en/point/project/#{project.id}")
    assert_link(nil, title: 'Point at this note',
                     href: "#{host}/en/point/note/#{note.id}")
  end

  test 'show that location borders a sea' do
    fabular_city = create(:location, name: 'Fabular City', seashore: true)
    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'Borders a sea'
  end

  test 'show that location borders a lake' do
    fabular_city = create(:location, name: 'Fabular City', lakeshore: true)
    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'Borders a lake'
  end
end
