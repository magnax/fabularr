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
      event: {
        body: Faker::Lorem.sentence,
        receiver_character_id: @other_character.id
      }
    }

    assert_difference -> { Event.count }, 1 do
      post events_route, params: params
    end

    assert_response :no_content
  end

  test 'create event and redirect' do
    params = {
      event: {
        body: Faker::Lorem.sentence,
        receiver_character_id: @other_character.id,
        reload: true
      }
    }

    assert_difference -> { Event.count }, 1 do
      post events_route, params: params
    end

    assert_response :found
    assert_redirected_to '/en/events'
  end
end
