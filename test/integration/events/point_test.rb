# frozen_string_literal: true

require 'test_helper'

class EventsPointTest < ActionDispatch::IntegrationTest
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

  test 'point to character' do
    get "/en/point/character/#{@character.id}"

    assert_response :found
  end
end
