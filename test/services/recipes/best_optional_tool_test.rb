# frozen_string_literal: true

require 'test_helper'

class RecipesBestOptionalToolTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(recipe)
    Recipes::BestOptionalTool.call(@character, recipe)
  end

  test 'one optional tool in recipe and in inventory' do
    knife_type = create(:item_type, key: 'stone_knife')
    knife = create(:item, item_type: knife_type)

    create(:inventory_object, character: @character, subject: knife)

    recipe = create(:recipe, recipe_type: 'collect')
    create(:recipe_instruction, :tool, recipe: recipe, subject: knife_type, speed: 1.5)

    result = call_service(recipe)

    assert_equal 'stone_knife', result
  end

  test 'many optional tools in inventory' do
    knife_type = create(:item_type, key: 'stone_knife')
    axe_type = create(:item_type, key: 'stone_axe')
    knife = create(:item, item_type: knife_type)
    axe = create(:item, item_type: axe_type)

    create(:inventory_object, character: @character, subject: knife)
    create(:inventory_object, character: @character, subject: axe)

    recipe = create(:recipe, recipe_type: 'collect')
    create(:recipe_instruction, :tool, recipe: recipe, subject: knife_type, speed: 1.5)
    create(:recipe_instruction, :tool, recipe: recipe, subject: axe_type, speed: 2)

    result = call_service(recipe)

    assert_equal 'stone_axe', result
  end
end
