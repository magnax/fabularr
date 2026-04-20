# frozen_string_literal: true

require 'test_helper'

class LocationsNameTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    character = create(:character, user: @user, name: 'Magnus')
    create(:location_name, location: character.location, character: character, name: 'Fabular City')

    sign_in @user
    click_on 'Magnus'
  end

  test 'show location name page' do
    click_on 'Fabular City'

    assert_content 'Current name: Fabular City'
    assert_selector :button, 'Rename'
  end
end
