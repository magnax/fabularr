# frozen_string_literal: true

require 'test_helper'

class LocationObjectsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @location = @character.location
  end

  def call_service(params)
    LocationObjects::CreateService.call(@character, params)
  end

  test 'empty params' do
    assert_raise LocationObjects::CreateService::InvalidParamsError do
      call_service({})
    end
  end

  test 'create location object for valid params' do
    iron = create(:resource, key: 'iron')
    inventory_iron = create(:inventory_object, character: @character,
                                               subject: iron, amount: 100)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '20'
    }

    assert_difference -> { LocationObject.count }, 1 do
      call_service(params)
    end

    loc = @character.reload.location.location_objects.sole
    assert_equal 20, loc.amount

    assert_equal 80, inventory_iron.reload.amount
  end

  test 'update location object for existing resource' do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @character.location,
                                             subject: iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: iron,
                                               amount: 50)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '20'
    }

    assert_difference -> { LocationObject.count }, 0 do
      call_service(params)
    end

    assert_equal 30, character_iron.reload.amount
    assert_equal 120, location_iron.reload.amount
  end

  test 'drop all when requested amount is greater then available' do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @character.location,
                                             subject: iron, amount: 100)
    create(:inventory_object, character: @character, subject: iron,
                              amount: 50)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '200'
    }

    assert_difference -> { InventoryObject.count }, -1 do
      call_service(params)
    end

    assert_equal 150, location_iron.reload.amount
  end
end
