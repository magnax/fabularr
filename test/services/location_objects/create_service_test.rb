# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

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
                              amount: 50, unit: nil)
    second_character = create(:character, location: @character.location)

    params = {
      subject_id: iron.id,
      subject_type: 'Resource',
      amount: '200'
    }

    assert_difference -> { InventoryObject.count } => -1,
                      -> { Event.count } => 2 do
      call_service(params)
    end

    assert_equal 150, location_iron.reload.amount

    ev = @character.visible_events.sole

    assert_equal @character.id, ev.receiver_character_id
    assert_equal 'You drop 50 grams of iron', ev.body

    ev = second_character.visible_events.sole

    assert_equal second_character.id, ev.receiver_character_id
    assert_nil ev.character_id
    assert_equal "You see that <!--CHARID:#{@character.id}--> is dropping some iron", ev.body
  end

  test 'drop item from inventory' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    inv_knife = create(:inventory_object, character: @character, subject: knife)
    second_character = create(:character, location: @character.location)

    params = {
      inventory_object_id: inv_knife.id
    }

    assert_difference(
      -> { InventoryObject.count } => -1,
      -> { LocationObject.count } => 1,
      -> { Event.count } => 2
    ) do
      call_service(params)
    end

    ev = @character.visible_events.sole
    assert_equal 'You drop a stone knife', ev.body

    ev = second_character.visible_events.sole
    assert_nil ev.character_id
    assert_equal "You see that <!--CHARID:#{@character.id}--> is dropping a stone knife", ev.body
  end

  test 'dropping item which is not needed in current project' do
    item_type_knife = create(:item_type, key: 'stone_knife')
    item_type_hammer = create(:item_type, key: 'stone_hammer')
    knife = create(:item, item_type: item_type_knife)
    hammer = create(:item, item_type: item_type_hammer)
    create(:inventory_object, character: @character, subject: knife)
    inv_hammer = create(:inventory_object, character: @character, subject: hammer)

    recipe = create(:recipe)
    create(:recipe_instruction, :tool, recipe: recipe, subject: item_type_knife)
    project = create(:project, :build, recipe: recipe)
    worker = create(:worker, :working, project: project, character: @character)

    params = {
      inventory_object_id: inv_hammer.id
    }

    call_service(params)

    assert_nil worker.reload.left_at
  end

  test 'dropping item which is needed in project will terminate working' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    inv_knife = create(:inventory_object, character: @character, subject: knife)

    recipe = create(:recipe, recipe_type: Recipe::BUILD)
    create(:recipe_instruction, :tool, recipe: recipe, subject: item_type)
    project = create(:project, :build, recipe: recipe)
    worker = create(:worker, :working, project: project, character: @character)

    params = {
      inventory_object_id: inv_knife.id
    }

    call_service(params)

    assert_not_nil worker.reload.left_at
  end

  test 'dropping item which is needed but duplicated in inventory' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)
    second_knife = create(:item, item_type: item_type)

    inv_knife = create(:inventory_object, character: @character, subject: knife)
    create(:inventory_object, character: @character, subject: second_knife)

    recipe = create(:recipe)
    create(:recipe_instruction, :tool, recipe: recipe, subject: item_type)
    project = create(:project, :build, recipe: recipe)
    worker = create(:worker, :working, project: project, character: @character)

    params = {
      inventory_object_id: inv_knife.id
    }

    call_service(params)

    assert_nil worker.reload.left_at
  end

  test 'dropping item which is optional will add worker with new speed' do
    item_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: item_type)

    inv_knife = create(:inventory_object, character: @character, subject: knife)

    recipe = create(:recipe, recipe_type: 'collect')
    create(:recipe_instruction, :tool, recipe: recipe, subject: item_type, speed: 1.8)
    project = create(:project, :collect, recipe: recipe)
    worker = create(:worker, :working, project: project, character: @character, speed: 1.8)

    params = {
      inventory_object_id: inv_knife.id
    }

    assert_difference -> { Worker.count } => 1 do
      call_service(params)
    end

    assert_not_nil worker.reload.left_at
    new_worker = Worker.where(left_at: nil).sole
    assert_equal 1, new_worker.speed
  end

  test 'dropping item which is optional but not the best that user has' do
    knife_type = create(:item_type, key: 'stone_knife')
    axe_type = create(:item_type, key: 'stone_axe')
    knife = create(:item, item_type: knife_type)
    axe = create(:item, item_type: axe_type)

    inv_knife = create(:inventory_object, character: @character, subject: knife)
    create(:inventory_object, character: @character, subject: axe)

    recipe = create(:recipe, recipe_type: 'collect')
    create(:recipe_instruction, :tool, recipe: recipe, subject: knife_type, speed: 1.5)
    create(:recipe_instruction, :tool, recipe: recipe, subject: axe_type, speed: 2)
    project = create(:project, :collect, recipe: recipe)
    worker = create(:worker, :working, project: project, character: @character, speed: 2)

    params = {
      inventory_object_id: inv_knife.id
    }

    assert_difference -> { Worker.count } => 0 do
      call_service(params)
    end

    assert_nil worker.reload.left_at
    assert_equal 2, worker.reload.speed
  end

  test 'dropping optional best item' do
    knife_type = create(:item_type, key: 'stone_knife')
    axe_type = create(:item_type, key: 'stone_axe')
    knife = create(:item, item_type: knife_type)
    axe = create(:item, item_type: axe_type)

    create(:inventory_object, character: @character, subject: knife)
    inv_axe = create(:inventory_object, character: @character, subject: axe)

    recipe = create(:recipe, recipe_type: 'collect')
    create(:recipe_instruction, :tool, recipe: recipe, subject: knife_type, speed: 1.5)
    create(:recipe_instruction, :tool, recipe: recipe, subject: axe_type, speed: 2)
    project = create(:project, :collect, recipe: recipe)
    worker = create(:worker, :working, project: project, character: @character, speed: 2)

    params = {
      inventory_object_id: inv_axe.id
    }

    assert_difference -> { Worker.count } => 1 do
      call_service(params)
    end

    assert_not_nil worker.reload.left_at
    new_worker = Worker.where(left_at: nil).sole
    assert_equal 1.5, new_worker.speed
  end
end

# rubocop:enable Metrics/ClassLength
