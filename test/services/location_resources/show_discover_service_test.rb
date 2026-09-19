# frozen_string_literal: true

require 'test_helper'

class LocationResourcesShowDiscoverServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)

    @project_type = create(:project_type, key: 'discover_resource')
  end

  def call_service
    LocationResources::ShowDiscoverService.call(@character)
  end

  test 'raise error when user not in location' do
    @character.update!(location: nil)

    assert_raises LocationResources::InvalidLocationError do
      call_service
    end
  end

  test 'raise error when invalid location (vehicle)' do
    vehicle = create(:location, :vehicle, parent_location: @location)
    @character.update!(location: vehicle)

    assert_raises LocationResources::InvalidLocationError do
      call_service
    end
  end

  test 'raise error when invalid location (building)' do
    building = create(:location, :building, parent_location: @location)
    @character.update!(location: building)

    assert_raises LocationResources::InvalidLocationError do
      call_service
    end
  end

  test 'returns proper data' do
    res = call_service

    assert_equal @project_type.id, res[:project_type_id]
    assert_equal @location.id, res[:location_id]
  end
end
