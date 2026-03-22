# frozen_string_literal: true

require 'test_helper'

class Projects::EndServiceTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test 'broadcasting end project message to worker' do
    starting_character = create(:character)
    worker_character = create(:character)
    project = create(:project, :discover_resource,
                     starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'event',
      event_id: Event.where(receiver_character_id: worker_character.id).last.id,
      receiver_id: worker_character.id
    )
  end

  test 'broadcasting end project to starting character' do
    location = create(:location)
    starting_character = create(:character, location: location)
    worker_character = create(:character, location: location)
    project = create(:project, :discover_resource,
                     location: location, starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'event',
      event_id: Event.where(receiver_character_id: starting_character.id).last.id,
      receiver_id: starting_character.id
    )
  end

  test 'broadcasting end project to location' do
    location = create(:location)
    starting_character = create(:character, location: location)
    worker_character = create(:character, location: location)
    project = create(:project, :discover_resource,
                     location: location,
                     starting_character: starting_character)
    create(:worker, project: project, character: worker_character)

    call_service(project.id)

    assert_broadcast_on(
      "location_#{project.location_id}",
      type: 'project.end',
      project_id: project.id
    )
  end

  test '#discover_resource does not create resource if no resources defined' do
    location = create(:location)
    starting_character = create(:character, location: location)
    project = create(:project, :discover_resource, location: location,
                                                   starting_character: starting_character)
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationResource.count }, 0 do
      call_service(project.id)
    end
  end

  test '#discover_resource creates food resource in location' do
    type = create(:location_type, key: 'meadow')
    location = create(:location, location_type: type)

    food_type = create(:resource_type, key: 'food')
    other_type = create(:resource_type, key: 'material')

    create(:resource, key: 'wood', resource_type_id: [other_type.id])
    resource = create(:resource, key: 'mushrooms', resource_type_id: [food_type.id])

    starting_character = create(:character, location: location)
    project = create(:project, :discover_resource, location: location,
                                                   starting_character: starting_character)
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationResource.count }, 1 do
      call_service(project.id)
    end

    assert_equal resource.id, location.reload.location_resources.sole.resource_id

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_equal 'Project started by you has just ended. Found new resource: mushrooms', event.body
  end

  test '#collect creates resource in location' do
    type = create(:location_type, key: 'meadow')
    location = create(:location, location_type: type)

    food_type = create(:resource_type, key: 'food')

    resource = create(:resource, key: 'mushrooms', resource_type_id: [food_type.id])

    starting_character = create(:character, location: location)
    project = create(:project, :collect, location: location,
                                         starting_character: starting_character)
    create(:project_description, project: project, subject: resource, amount: 100,
                                 unit: 'grams')
    create(:worker, project: project, character: starting_character)

    assert_difference -> { LocationObject.count }, 1 do
      call_service(project.id)
    end

    assert_equal resource.id, location.reload.location_objects.sole.subject_id
    assert_equal 'Resource', location.reload.location_objects.sole.subject_type

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_match(/Project started by you has just ended. (\d{2,3}) grams of mushrooms landed on the ground/, event.body)
  end

  test "#build creates manufactured item in character's inventory" do
    location = create(:location)

    resource = create(:resource, :material, key: 'stone')
    create(:item_type, key: 'stone_knife', weight: 120)
    recipe = create(:recipe, key: 'stone_knife')
    create(:recipe_instruction, recipe: recipe,
                                instruction_type: 'resource', subject: resource, amount: 100)

    starting_character = create(:character, location: location)
    project = create(:project, :build, location: location,
                                       starting_character: starting_character,
                                       recipe: recipe)
    create(:project_description, project: project, subject: resource, amount: 100,
                                 unit: 'grams')
    create(:worker, project: project, character: starting_character)
    create(:inventory_object, character: starting_character,
                              subject: resource, amount: 100)

    assert_difference -> { InventoryObject.count }, 1 do
      call_service(project.id)
    end

    assert_equal 220, starting_character.carrying_weight

    inv_object = starting_character.reload.inventory_objects.item.sole
    assert_equal 'Item', inv_object.subject_type
    assert_equal recipe.key, inv_object.subject.item_type.key

    event = Event.where(receiver_character_id: starting_character.id).last
    assert_match(/Project started by you has just ended. Manufactured: stone knife/, event.body)
  end
end
