# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @iron = create(:resource, key: 'iron')
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
    location_iron = create(:location_object, location: @character.location,
                                             subject: @iron, amount: 100)

    params = {
      subject_id: @iron.id,
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
    location_iron = create(:location_object, location: @character.location,
                                             subject: @iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: @iron,
                                               amount: 50)

    params = {
      subject_id: @iron.id,
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
    create(:location_object, location: @character.location,
                             subject: @iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: @iron,
                                               amount: 50)

    params = {
      subject_id: @iron.id,
      subject_type: 'Resource',
      amount: '200'
    }

    assert_difference -> { LocationObject.count }, -1 do
      call_service(params)
    end

    assert_equal 150, character_iron.reload.amount
  end

  test "can take only up to character's inventory capacity" do
    location_iron = create(:location_object, location: @character.location,
                                             subject: @iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: @iron,
                                               amount: 14_950)

    params = {
      subject_id: @iron.id,
      subject_type: 'Resource',
      amount: '60'
    }

    call_service(params)

    assert_equal Character::MAX_CAPACITY, character_iron.reload.amount
    assert_equal 50, location_iron.reload.amount
  end

  test "can take only up to character's inventory capacity and all from location" do
    create(:location_object, location: @character.location,
                             subject: @iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: @iron,
                                               amount: 14_800)

    params = {
      subject_id: @iron.id,
      subject_type: 'Resource',
      amount: '300'
    }
    assert_difference -> { LocationObject.count }, -1 do
      call_service(params)
    end

    assert_equal 14_900, character_iron.reload.amount
  end

  test "can take only up to character's inventory capacity and not all from location" do
    location_iron = create(:location_object, location: @character.location,
                                             subject: @iron, amount: 100)
    character_iron = create(:inventory_object, character: @character, subject: @iron,
                                               amount: 14_950)

    params = {
      subject_id: @iron.id,
      subject_type: 'Resource',
      amount: '300'
    }

    call_service(params)

    assert_equal Character::MAX_CAPACITY, character_iron.reload.amount
    assert_equal 50, location_iron.reload.amount
  end

  test 'events after taking resource from the ground' do
    second_character = create(:character, location: @character.location)

    create(:location_object, location: @character.location,
                             subject: @iron, amount: 100)

    params = {
      subject_id: @iron.id,
      subject_type: 'Resource',
      amount: '20'
    }
    assert_difference -> { Event.count }, 2 do
      call_service(params)
    end

    ev = @character.visible_events.last
    assert_equal "You're taking 20 grams of iron from the ground", ev.body

    ev = second_character.visible_events.last
    assert_equal(
      "You see that <!--CHARID:#{@character.id}--> is taking some iron from the ground",
      ev.body
    )
  end

  test 'taking item from the ground' do
    second_character = create(:character, location: @character.location)
    item_type = create(:item_type, key: 'iron_knife')
    iron_knife = create(:item, item_type: item_type)
    location_iron_knife = create(:location_object, location: @character.location,
                                                   subject: iron_knife)

    params = {
      location_object_id: location_iron_knife.id
    }
    assert_difference -> { Event.count } => 2,
                      -> { InventoryObject.count } => 1,
                      -> { LocationObject.count } => -1 do
      call_service(params)
    end

    ev = @character.visible_events.last
    assert_equal "You're taking iron knife", ev.body

    ev = second_character.visible_events.last
    assert_equal(
      "You see that <!--CHARID:#{@character.id}--> is taking iron knife",
      ev.body
    )
  end
end
