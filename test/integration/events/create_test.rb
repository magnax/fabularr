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

    assert_difference -> { Event.count }, 2 do
      post events_route, params: params
    end

    assert_response :found

    ev = Event.where(receiver_character_id: @character.id).sole
    assert_equal "You say to <!--CHARID:#{@other_character.id}-->: #{params[:event][:body]}", ev.body

    ev = Event.where(receiver_character_id: @other_character.id).sole
    assert_equal "<!--CHARID:#{@character.id}--> says to You: #{params[:event][:body]}", ev.body
  end

  test 'character can talk to all' do
    vehicle = create(:location, :vehicle, parent_location: @location)
    create(:character, location: vehicle)

    params = {
      event: {
        body: Faker::Lorem.sentence
      }
    }

    assert_difference -> { Event.count }, 3 do
      post events_route, params: params
    end

    assert_response :found

    assert_empty Event.pluck(:character_id).compact

    ev = Event.where(receiver_character_id: @character.id).sole
    assert_equal "You say: #{params[:event][:body]}", ev.body

    ev = Event.where(receiver_character_id: @other_character.id).sole
    assert_equal "<!--CHARID:#{@character.id}--> says: #{params[:event][:body]}", ev.body
  end

  test 'create event and redirect' do
    params = {
      event: {
        body: Faker::Lorem.sentence,
        receiver_character_id: @other_character.id,
        reload: true
      }
    }

    assert_difference -> { Event.count }, 2 do
      post events_route, params: params
    end

    assert_response :found
    assert_redirected_to '/en/events'
  end
end
