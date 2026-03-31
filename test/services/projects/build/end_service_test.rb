# frozen_string_literal: true

require 'test_helper'

class ProjectsBuildEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
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

  test '#build/building creates building in location' do
    location = create(:location)
    create(:location_type, key: 'wood_shack')
    create(:location_class, key: 'building')

    wood = create(:resource, :material, key: 'wood')
    recipe = create(:recipe, recipe_type: 'building', key: 'wood_shack', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: wood,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')

    starting_character = create(:character, location: location)
    project = create(:project, :build, location: location,
                                       starting_character: starting_character,
                                       recipe: recipe)
    create(:project_description, project: project, subject: wood, amount: 100,
                                 unit: 'grams')
    create(:worker, project: project, character: starting_character)

    assert_difference -> { InventoryObject.count } => 0,
                      -> { Location.count } => 1 do
      call_service(project.id)
    end

    assert_equal 1, location.reload.buildings.length

    new_location = Location.last
    assert_equal location.coords, new_location.coords
  end
end
