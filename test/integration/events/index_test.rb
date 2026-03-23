# frozen_string_literal: true

require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
  end

  def sign_in
    visit login_path

    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end

  test 'not logged in user' do
    visit events_url

    assert_text 'Fabular login'
  end

  test 'logged in user without character set' do
    sign_in
    visit events_url

    assert_text 'Hello user@me.com'
  end

  test 'signed-in user with some characters' do
    fabular_city = create(:location, name: 'Fabular City')
    other_city = create(:location, name: 'Other City')
    create(:character, name: 'Magnus', location: fabular_city, user: @user)
    create(:character, name: 'Ella', gender: 'K', location: fabular_city, user: @user)
    create(:character, name: 'Sid', location: other_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_content('Events for: Magnus')
    assert_content('Location: Fabular City')
    assert_link('Magnus')
    assert_link('unknown woman')
    assert_no_link('Sid')
    assert_content('Resources')
    assert_content('Items')
    assert_content('Projects')
    assert_link('Discover new resource')
  end

  test 'link to collect resource on events page' do
    fabular_city = create(:location, name: 'Fabular City')
    lr = create(:location_resource, location: fabular_city,
                                    resource: create(:resource, key: 'mushrooms'))
    create(:character, name: 'Magnus', location: fabular_city, user: @user)

    sign_in
    click_link 'Magnus'

    assert_content('mushrooms')
    assert_link(
      'Collect', href: "http://www.example.com/en/projects/new/collect/#{lr.id}"
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

    sign_in
    click_link 'Magnus'

    assert_content 'Take 200 grams mushrooms'
    assert_link 'Take', href: "#{host}/en/location_objects/#{lr.id}/take"
    assert_content 'Take brand new stone knife'
    assert_link 'Take', href: "#{host}/en/location_objects/#{location_knife.id}/take_item"
  end
end
