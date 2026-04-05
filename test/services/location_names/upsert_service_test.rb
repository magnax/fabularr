# frozen_string_literal: true

require 'test_helper'

class LocationNamesUpsertServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(params)
    LocationNames::UpsertService.call(@character, params)
  end

  test 'create new location name' do
    location = create(:location)

    params = {
      location_id: location.id,
      name: Faker::Address.city
    }

    assert_difference -> { LocationName.count } => 1 do
      call_service(params)
    end

    l_name = LocationName.last
    assert_equal params[:name], l_name.name
  end

  test 'update existing location name' do
    location = create(:location)
    l_name = create(:location_name, location: location, character: @character, name: 'Town')

    params = {
      location_id: location.id,
      name: Faker::Address.city
    }

    assert_difference -> { LocationName.count } => 0 do
      call_service(params)
    end

    assert_equal params[:name], l_name.reload.name
  end

  test 'destroy location name - back to default name' do
    location = create(:location)
    create(:location_name, location: location, character: @character, name: 'Town')

    params = {
      location_id: location.id,
      name: ''
    }

    assert_difference -> { LocationName.count } => -1 do
      call_service(params)
    end

    assert_equal 0, @character.reload.location_names.count
    assert_equal 'unnamed place', location.display_name(@character)
  end
end
