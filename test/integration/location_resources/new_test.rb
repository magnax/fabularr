# frozen_string_literal: true

require 'test_helper'

class LocationResourcesNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@character)
  end

  test 'show page' do
    create(:project_type, key: 'discover_resource')
    location = create(:location)

    get "/locations/#{location.id}/location_resources/new"

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'Discover new resources!'
  end
end
