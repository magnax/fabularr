# frozen_string_literal: true

require 'test_helper'

class SeedsRecipesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { Recipe.count } => 7,
                      -> { RecipeInstruction.count } => 11 do
      require_relative '../../db/seeds/recipes'
    end

    machinery_recipe = Recipe.find_by(key: 'small_fire_pit')
    assert_equal Recipe::MACHINERY, machinery_recipe.recipe_type

    instruction = machinery_recipe.recipe_instructions.resource.sole
    assert_equal RecipeInstruction::RESOURCE, instruction.instruction_type
    assert_equal 'stone', instruction.subject.key
  end
end
