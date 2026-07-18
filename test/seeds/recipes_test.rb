# frozen_string_literal: true

require 'test_helper'

class SeedsRecipesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { Recipe.count } => 14,
                      -> { RecipeInstruction.count } => 32 do
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

    # assert conversion from '2d' (2 days) to seconds
    lasso_recipe = Recipe.find_by(key: 'lasso', recipe_type: Recipe::ITEM)
    assert_equal 86_400 * 2, lasso_recipe.base_speed

    # assert placement instruction
    pit_recipe = Recipe.find_by(
      key: 'small_fire_pit', recipe_type: Recipe::MACHINERY
    )
    assert_equal 'outside_all',
                 pit_recipe.recipe_instructions.placement.sole.metadata['placement'].sole

    # assert options for items used & portable attribute
    option_item_recipe = Recipe.find_by(
      key: 'drop_spindle', recipe_type: Recipe::MACHINERY
    )
    assert_equal Skill::MANUFACTURING_MACHINES, option_item_recipe.skill.key
    assert_equal 86_400, option_item_recipe.base_speed
    instruction = option_item_recipe.recipe_instructions.item.sole
    assert instruction.subject.virtual

    machinery = Machinery.find_by(key: option_item_recipe[:key])
    assert machinery.portable

    knife = ItemType.find_by(key: 'knife')
    assert knife.virtual

    steel_knife = ItemType.find_by(key: 'steel_knife')
    assert_not steel_knife.virtual
  end

  def teardown
    Resource.destroy_all
    Skill.destroy_all
    ItemType.destroy_all
  end
end
