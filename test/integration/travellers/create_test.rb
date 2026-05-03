# frozen_string_literal: true

require 'test_helper'

class TravellersCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, location: @location, name: 'Magnus', user: @user)
  end

  def start_travel
    click_link 'Start travel'
    assert_content 'Direction in degrees'
    fill_in 'traveller_direction', with: '45'
    click_on 'Go now!'
  end

  test 'starts new travel' do
    sign_in(@user)
    click_link 'Magnus'

    assert_difference -> { Traveller.count } => 1 do
      start_travel
    end
  end

  test 'starts new travel using road' do
    other_location = create(:location, coords: { x: @location.x + 50, y: @location.y })
    road = create(:road, location_1: @location, location_2: other_location)

    login(@user, @character)

    params = {
      traveller: {
        road_id: road.id
      }
    }

    assert_difference -> { Traveller.count } => 1,
                      -> { Event.count } => 1 do
      post '/en/travellers', params: params
    end

    traveller = Traveller.last
    assert_equal 0, traveller.direction
    assert_equal road.id, traveller.road_id

    e = Event.last
    assert_equal "You're leaving <!--LOCID:#{@location.id}--> taking path to <!--LOCID:#{other_location.id}-->", e.body
  end

  test 'other characters in location are not visible after starting travel' do
    other_character = create(:character, location: @location)
    other_travelling_character = create(:character, location: nil,
                                                    coords: { x: 102, y: 102 })
    create(:traveller, subject: other_travelling_character)

    create(:char_name, character: @character, named: other_character, name: 'Sid')
    create(:char_name, character: @character,
                       named: other_travelling_character, name: 'Ella')

    sign_in(@user)
    click_link 'Magnus'

    assert_link 'Sid', href: "#{host}/en/characters/#{other_character.id}/name"
    assert_no_link 'Ella', href: "#{host}/en/characters/#{other_travelling_character.id}/name"

    start_travel

    assert_no_link 'Sid', href: "#{host}/en/characters/#{other_character.id}/name"
    assert_link 'Ella', href: "#{host}/en/characters/#{other_travelling_character.id}/name"
  end
end
