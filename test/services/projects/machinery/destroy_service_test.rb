# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryDestroyServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, name: 'Magnus', location: @location)
    @skill = create(:skill, key: Skill::COOKING)

    @pit = create(:machinery, key: 'small_fire_pit')
    @machine = create(:location_object, subject: @pit, location: @location)

    @meat = create(:resource, :raw_food, key: 'meat')
    @dung = create(:resource, :raw_resource, key: 'dried_dung')
    @grilled_meat = create(:resource, :food, key: 'grilled_meat')
  end

  def call_service(project_id)
    Projects::DestroyService.call(@character, project_id)
  end

  def create_recipe!
    @recipe = create(:recipe, key: 'grilled_meat_dung', recipe_type: Recipe::GRILLING,
                              skill: @skill)
    create(:recipe_instruction, recipe: @recipe, subject: @meat, amount: 250)
    create(:recipe_instruction, recipe: @recipe, subject: @dung, amount: 150)
    create(:recipe_instruction, :resource_out, recipe: @recipe,
                                               subject: @grilled_meat, amount: 225)
    create(:recipe_instruction, :machinery, recipe: @recipe, subject: @pit)
    create(:recipe_instruction, :max_amount, recipe: @recipe, subject: nil, amount: 18_000)
  end

  test 'destroys project and returns back materials' do
    create_recipe!

    project = create(:project, :machinery, recipe: @recipe,
                                           location: @location, starting_character: @character)
    create(:project_description, :resource_in,
           project: project, subject: @meat, amount: 300, amount_needed: 600)
    create(:project_description, :resource_in,
           project: project, subject: @dung, amount: 0, amount_needed: 500)

    assert_difference -> { Project.count } => -1,
                      -> { InventoryObject.count } => 1 do
      call_service(project.id)
    end

    assert_equal 300, @character.reload.inventory_objects.resource.sole.amount
  end

  test 'destroys project but returns materials to the ground' do
    create_recipe!

    project = create(:project, :machinery, recipe: @recipe,
                                           location: @location, starting_character: @character)
    create(:project_description, :resource_in,
           project: project, subject: @meat, amount: 300, amount_needed: 600)
    create(:project_description, :resource_in,
           project: project, subject: @dung, amount: 0, amount_needed: 500)
    create(:inventory_object, character: @character, subject: @dung,
                              amount: 14_701)

    assert_difference -> { Project.count } => -1,
                      -> { LocationObject.count } => 1 do
      call_service(project.id)
    end

    assert_equal 14_701, @character.reload.inventory_objects.resource.sole.amount
  end

  test 'do not allow to destroy project when no owner' do
    create_recipe!

    project = create(:project, :machinery,
                     recipe: @recipe, location: @location,
                     starting_character: create(:character))
    create(:project_description, :resource_in,
           project: project, subject: @meat, amount: 300, amount_needed: 600)
    create(:project_description, :resource_in,
           project: project, subject: @dung, amount: 0, amount_needed: 500)

    assert_raises Projects::NotOwnerError do
      call_service(project.id)
    end
  end

  # TODO: Edge cases:
  # - return proportional amount of already produced result and remaining resources
end
