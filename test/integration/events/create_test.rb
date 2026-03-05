# frozen_string_literal: true

require 'test_helper'

class EventsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)
    @other_character = create(:character, location: @location)

    login(user, @character)
  end

  def events_route
    '/events'
  end

  test 'character can talk to another character' do
    params = {
      body: Faker::Lorem.sentence,
      location_id: @location.id,
      character_id: @character.id,
      receiver_character_id: @other_character.id
    }

    assert_difference -> { Event.count }, 1 do
      post events_route, params: params
    end

    assert_response :no_content
  end
end
