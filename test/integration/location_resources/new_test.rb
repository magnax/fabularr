# frozen_string_literal: true

require 'test_helper'

class LocationResourcesNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, location: @location, name: 'Magnus', user: @user)
    create(:project_type, key: 'discover_resource')

    login(@user, @character)
  end

  test 'shows error message when invalid location' do
    building = create(:location, :building, parent_location: @location)
    @character.update!(location: building)

    get '/location_resources'

    assert_response :found
    assert_redirected_to '/en/events'
  end

  test 'show page' do
    get '/location_resources'

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'Discover new resources!'
  end
end
