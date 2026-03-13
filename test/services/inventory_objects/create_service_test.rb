require 'test_helper'

class InventoryObjectsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(params)
    InventoryObjects::CreateService.call(@character, params)
  end

  test 'empty params' do
    assert_raise InventoryObjects::CreateService::InvalidParamsError do
      call_service({})
    end
  end

  test 'create inventory object for valid params' do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @character.location,
                                             subject: iron, amount: 100)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '20'
    }

    assert_difference -> { InventoryObject.count }, 1 do
      call_service(params)
    end

    inv = @character.reload.inventory_objects.sole
    assert_equal 20, inv.amount

    assert_equal 80, location_iron.reload.amount
  end

  test 'update inventory object for existing resource' do
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

    assert_difference -> { InventoryObject.count }, 0 do
      call_service(params)
    end

    assert_equal 70, character_iron.reload.amount
    assert_equal 80, location_iron.reload.amount
  end

  test 'take all when requested amount is greater then available' do
    iron = create(:resource, key: 'iron')
    create(:location_object, location: @character.location,
                             subject: iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: iron,
                                               amount: 50)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '200'
    }

    assert_difference -> { LocationObject.count }, -1 do
      call_service(params)
    end

    assert_equal 150, character_iron.reload.amount
  end

  test "can take only up to character's inventory capacity" do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @character.location,
                                             subject: iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: iron,
                                               amount: 14_950)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '60'
    }

    call_service(params)

    assert_equal Character::MAX_CAPACITY, character_iron.reload.amount
    assert_equal 50, location_iron.reload.amount
  end

  test "can take only up to character's inventory capacity and all from location" do
    iron = create(:resource, key: 'iron')
    create(:location_object, location: @character.location,
                             subject: iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: iron,
                                               amount: 14_800)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '300'
    }
    assert_difference -> { LocationObject.count }, -1 do
      call_service(params)
    end

    assert_equal 14_900, character_iron.reload.amount
  end

  test "can take only up to character's inventory capacity and not all from location" do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @character.location,
                                             subject: iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: iron,
                                               amount: 14_950)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '300'
    }

    call_service(params)

    assert_equal Character::MAX_CAPACITY, character_iron.reload.amount
    assert_equal 50, location_iron.reload.amount
  end
end
