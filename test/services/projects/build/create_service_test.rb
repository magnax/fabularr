# frozen_string_literal: true

require 'test_helper'

class ProjectsBuildCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'basic build - just one type of resource needed' do
    project_type = create(:project_type, key: 'build',
                                         base_speed: 0, fixed: true)
    stone = create(:resource, :material, key: 'stone')
    recipe = create(:recipe, key: 'stone_knife', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: stone,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')
    second_character = create(:character, location: @current_character.location)

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id
    }

    assert_difference(
      -> { Project.count } => 1,
      -> { ProjectDescription.count } => 1
    ) do
      call_service(params)
    end

    project = Project.last

    assert_equal 'build', project.project_type.key
    assert_equal 3600, project.duration
    assert_equal 0, project.elapsed
    assert_equal recipe.id, project.recipe_id
    assert_not project.ready

    desc = ProjectDescription.last
    assert_equal stone.id, desc.subject_id
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 100, desc.amount_needed
    assert_equal 'grams', desc.unit

    event = second_character.visible_events.last
    assert_equal(
      "You see that <!--CHARID:#{@current_character.id}--> is starting new project",
      event.body
    )
  end

  test 'build using tool and one type of resource' do
    project_type = create(:project_type, key: 'build',
                                         base_speed: 0, fixed: true)
    stone = create(:resource, :material, key: 'stone')
    item_type = create(:item_type, key: 'stone_knife')
    recipe = create(:recipe, key: 'wooden_shaft', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: stone,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')
    create(:recipe_instruction, recipe: recipe, subject: item_type,
                                amount: nil, unit: nil,
                                instruction_type: 'tool')

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id
    }

    assert_difference(
      -> { Project.count } => 1,
      -> { ProjectDescription.count } => 2
    ) do
      call_service(params)
    end

    desc = ProjectDescription.tool.last
    assert_equal item_type.id, desc.subject_id
    assert_equal 'ItemType', desc.subject_type
    assert_equal ProjectDescription::TOOL, desc.description_type
    assert_nil desc.amount
    assert_nil desc.amount_needed
    assert_nil desc.unit
  end

  test 'building - just material' do
    project_type = create(:project_type, key: 'build',
                                         base_speed: 0, fixed: true)
    wood = create(:resource, :material, key: 'wood')
    recipe = create(:recipe, recipe_type: 'building', key: 'wood_shack', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: wood,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id
    }

    assert_difference(
      -> { Project.count } => 1,
      -> { ProjectDescription.count } => 1
    ) do
      call_service(params)
    end
  end
end
