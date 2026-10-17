# frozen_string_literal: true

require 'test_helper'

class ShipActionsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location, coords: { x: 200, y: 100 })
    @character = create(:character, location: @location)
  end

  def call_service(params)
    ShipActions::CreateService.call(@character, params)
  end

  test 'raise error when not on ship' do
    params = {
      direction: 'w'
    }

    assert_raise Locations::MustBeOnShipError do
      call_service(params)
    end
  end

  test 'raise error when wrong direction (invalid param)' do
    ship = create(:location, :ship, parent_location: @location)
    @character.update!(location: ship)

    params = {
      direction: 'g'
    }

    assert_raise ShipActions::InvalidUndockDirectionError do
      call_service(params)
    end
  end

  test 'raise error when wrong direction (land)' do
    ship = create(:location, :ship, parent_location: @location)
    @character.update!(location: ship)
    location_type = create(:location_type, key: 'beach')
    Maps.expects(:location_type).with(180, 100).returns(location_type)

    params = {
      direction: 'w'
    }

    assert_raise ShipActions::InvalidUndockDirectionError do
      call_service(params)
    end
  end

  test 'create traveller' do
    ship = create(:location, :ship, parent_location: @location)
    @character.update!(location: ship)

    params = {
      direction: 'n'
    }

    assert_difference -> { Traveller.count } => 1 do
      call_service(params)
    end

    traveller = Traveller.last
    assert_equal ship, traveller.subject
    assert @character.reload.travelling?
    assert_equal 200, traveller.x
    assert_equal 80, traveller.y # undocking "north" so Y coord is decreased by 20
  end
end
