# frozen_string_literal: true

require 'test_helper'

class SeedsRecipesTest < ActiveSupport::TestCase
  def teardown
    Skill.destroy_all
  end

  test 'works' do
    assert_difference -> { Recipe.count } => 10,
                      -> { RecipeInstruction.count } => 25 do
      require_relative '../../db/seeds/recipes'
    end

    machinery_recipe = Recipe.find_by(key: 'small_fire_pit')
    assert_equal Recipe::MACHINERY, machinery_recipe.recipe_type
    assert_equal Skill::MANUFACTURING_MACHINES, machinery_recipe.skill.key

    cooking_recipe = Recipe.find_by(key: 'dried_dung', recipe_type: Recipe::DRYING)
    assert_equal Skill::COOKING, cooking_recipe.skill.key
    instruction = RecipeInstruction.where(recipe_id: cooking_recipe, instruction_type: RecipeInstruction::MACHINERY).sole
    assert_equal 'small_fire_pit', instruction.subject.key

    instruction = machinery_recipe.recipe_instructions.resource.sole
    assert_equal RecipeInstruction::RESOURCE, instruction.instruction_type
    assert_equal 'stone', instruction.subject.key
  end
end
