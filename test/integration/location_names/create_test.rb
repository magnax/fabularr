# frozen_string_literal: true

require 'test_helper'

class LocationNamesCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@user, @character)
  end

  test 'show page' do
    location = create(:location)

    params = {
      location_name: {
        character_id: @character.id,
        location_id: location.id,
        name: 'Potato Land'
      }
    }

    assert_difference -> { LocationName.count } => 1 do
      post '/location_names', params: params
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end
end
