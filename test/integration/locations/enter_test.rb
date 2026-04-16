# frozen_string_literal: true

require 'test_helper'

class LocationsEnterTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
    @character = create(:character, user: @user, name: 'Magnus')
  end

  test 'preserves old events and adds new' do
    sign_in(@user)
    building = create(:location, :building, parent_location: @character.location)
    create_list(:event, 3, location: @character.location, receiver_character: @character)

    click_on 'Magnus'

    assert_selector('.event', count: 3)
    visit "en/locations/#{building.id}/enter"

    assert_selector('.event', count: 4)
  end
end
