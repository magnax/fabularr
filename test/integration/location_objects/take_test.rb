# frozen_string_literal: true

require 'test_helper'

class LocationObjectsDropTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)

    login(user, @character)
  end

  def events_route(id)
    "/en/location_objects/#{id}/take"
  end

  test 'show take resource page' do
    stone = create(:resource, key: 'stone')
    loc_stone = create(:location_object, location: @location,
                                         subject: stone, amount: 100)

    get events_route(loc_stone.id)

    assert_response :ok

    assert_includes response.parsed_body.to_s, 'You can take max. 100 grams stone'
  end
end
