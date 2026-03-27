# frozen_string_literal: true

require 'test_helper'

class RecipesCheckToolRequirementsServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @project = create(:project)
  end

  def call_service
    Recipes::CheckToolRequirementsService.call(@character, @project)
  end

  test 'project does not have a recipe' do
    assert call_service
  end

  test 'project needs one tool, character does not have it' do
    recipe = create(:recipe, recipe_type: Recipe::BUILD)
    create(:recipe_instruction, :tool, recipe: recipe)

    @project.update!(recipe: recipe)

    assert_not call_service
  end

  test 'project needs one tool, character has it' do
    recipe = create(:recipe, recipe_type: Recipe::BUILD)
    recipe_instruction = create(:recipe_instruction, :tool, recipe: recipe)
    tool = create(:item, item_type: recipe_instruction.subject)
    create(:inventory_object, character: @character, subject: tool)

    @project.update!(recipe: recipe)

    assert call_service
  end

  test 'character has only one from many tools required' do
    recipe = create(:recipe, recipe_type: Recipe::BUILD)
    recipe_instruction = create(:recipe_instruction, :tool, recipe: recipe)
    create(:recipe_instruction, :tool, recipe: recipe)
    tool = create(:item, item_type: recipe_instruction.subject)
    create(:inventory_object, character: @character, subject: tool)

    @project.update!(recipe: recipe)

    assert_not call_service
  end

  test 'project has optional tool, character does not have it' do
    recipe = create(:recipe, recipe_type: Recipe::COLLECT)
    create(:recipe_instruction, :tool, recipe: recipe)

    @project.update!(recipe: recipe)

    assert call_service
  end

  test 'project has optional tool, character has it' do
    recipe = create(:recipe, recipe_type: Recipe::COLLECT)
    recipe_instruction = create(:recipe_instruction, :tool, recipe: recipe)
    tool = create(:item, item_type: recipe_instruction.subject)
    create(:inventory_object, character: @character, subject: tool)

    @project.update!(recipe: recipe)

    assert call_service
  end
end
