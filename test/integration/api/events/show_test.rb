# frozen_string_literal: true

require 'test_helper'

class ApiEventsShowTest < ActionDispatch::IntegrationTest
  def setup
    @location = create(:location)
    user = create(:user)
    @character = create(:character, user: user, location: @location)
    @other_character = create(:character, location: @location)

    login(@character)
  end

  def events_route(event_id, character_id)
    "/api/events/#{event_id}?character_id=#{character_id}"
  end

  test 'parse end project (discover_resource)' do
    event = create(:event, body: 'Project ended',
                           character_id: nil,
                           location_id: @location.id,
                           receiver_character_id: @character.id)

    get events_route(event.id, @character.id)

    assert_response :ok
  end
end
