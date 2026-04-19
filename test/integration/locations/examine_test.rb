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
    @character.update!(coords: { x: 100, y: 100 }, location: nil)
    create(:traveller, subject: @character, speed: 0)
    create(:project_type, key: 'create_location')

    sign_in(@user)
    click_link 'Magnus'

    visit examine_locations_url

    assert_selector :button, 'Create new location!'
  end

  test 'examine location page - start project' do
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
