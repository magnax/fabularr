# frozen_string_literal: true

require 'test_helper'

class LocationsExamineTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, user: @user, name: 'Magnus')
  end

  test 'examine location page - user not travelling' do
    sign_in(@user)
    click_link 'Magnus'

    visit examine_locations_url

    assert_content 'You have to travel'
  end

  test 'examine location page - user travelling' do
    @character.update!(coords: { x: 100, y: 100 }, location: nil)
    create(:traveller, subject: @character)

    sign_in(@user)
    click_link 'Magnus'

    visit examine_locations_url

    assert_content 'You have to stand still'
  end

  test 'examine location page - user in travel, standing' do
    location_type = create(:location_type, key: 'tundra')
    Maps.expects(:location_type).with(100, 100).returns(location_type)
    @character.update!(coords: { x: 100, y: 100 }, location: nil)
    create(:traveller, subject: @character, speed: 0)
    create(:project_type, key: 'create_location')

    sign_in(@user)
    click_link 'Magnus'

    visit examine_locations_url

    assert_selector :button, 'Create new location!'
    assert_selector 'section#map'
    assert_content 'Location type: tundra'
  end

  test 'examine location page - there is already started project' do
    location_type = create(:location_type, key: 'tundra')
    Maps.expects(:location_type).with(100, 100).returns(location_type)
    @character.update!(coords: { x: 100, y: 100 }, location: nil)
    create(:traveller, subject: @character, speed: 0)
    create(:project_type, key: 'create_location')
    other_character = create(:character, location: nil, coords: { x: 101, y: 99 })
    project = create(:project, :create_location, starting_character: other_character)
    create(:project_description, description_type: ProjectDescription::LOCATION,
                                 project: project, subject: nil,
                                 metadata: { coords: { x: 101, y: 99 } })

    sign_in(@user)
    click_link 'Magnus'

    visit examine_locations_url

    assert_no_selector :button, 'Create new location!'
    assert_selector 'section#map'
    assert_content 'Location type: tundra'
    assert_content 'Cannot create location - there is already project for that'
  end

  test 'examine location page - start project' do
    location_type = create(:location_type, key: 'tundra')
    Maps.expects(:location_type).with(100, 100).returns(location_type)
    @character.update!(coords: { x: 100, y: 100 }, location: nil)
    create(:traveller, subject: @character, speed: 0)
    create(:project_type, key: 'create_location')

    sign_in(@user)
    click_link 'Magnus'

    visit examine_locations_url
    click_on 'Create new location!'

    assert_content "You're starting new project: creating new location"

    # project should be visible to character starting it
    p = Project.last
    assert_link 'Join project', href: "#{host}/en/projects/#{p.id}/join"
  end
end
