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

  test 'point to road' do
    other_location = create(:location)
    road = create(:road, location_1: @location, location_2: other_location)
    get "/en/point/road/#{road.id}"

    assert_response :found
  end

  test 'point to note' do
    note = create(:note, title: 'Note 1')
    create(:location_object, location: @location, subject: note)

    assert_difference -> { Event.count } => 2 do
      get "/en/point/note/#{note.id}"
    end

    assert_response :found

    event = Event.where(receiver_character: @character).last
    assert_equal 'You point at note "Note 1"', event.body

    event = Event.where(receiver_character: @other_character).last
    assert_equal "You see <!--CHARID:#{@character.id}-->" \
                 ' pointing at note "Note 1"', event.body
  end

  test 'point to note from inventory' do
    note = create(:note, title: 'Note 1')
    create(:inventory_object, character: @character, subject: note)

    assert_difference -> { Event.count } => 2 do
      get "/en/point/note/#{note.id}"
    end

    assert_response :found

    event = Event.where(receiver_character: @character).last
    assert_equal 'You point at note "Note 1" from your inventory', event.body

    event = Event.where(receiver_character: @other_character).last
    assert_equal "You see <!--CHARID:#{@character.id}-->" \
                 ' pointing at note "Note 1" from his/her inventory', event.body
  end
end
