# frozen_string_literal: true

require 'test_helper'

class RecipesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    sign_in
    click_link 'Magnus'
  end

  test 'no recipes available' do
    visit '/en/recipes'

    assert_equal 200, page.status_code
    assert_content 'Select what you want to make (recipes: 0)'
  end

  test 'show available recipes: items, buildings, vehicles' do
    create(:recipe, recipe_type: Recipe::BUILDING, key: 'wood_shack')
    create(:recipe, recipe_type: Recipe::ITEM, key: 'stone_knife')
    create(:recipe, recipe_type: Recipe::VEHICLE, key: 'small_wooden_cart')
    create(:recipe, recipe_type: Recipe::COLLECT, key: 'wood')

    visit '/en/recipes'

    assert_equal 200, page.status_code
    assert_content 'Select what you want to make (recipes: 3)'
    assert_content 'stone knife'
    assert_content 'wood shack'
    assert_content 'small wooden cart'
  end

  test 'show project setup page for given recipe' do
    recipe = create(:recipe, recipe_type: Recipe::ITEM, base_speed: 7200,
                             key: 'stone_knife')
    create(:project_type, :build)

    visit "/en/recipes?expanded[]=#{recipe.id}"

    assert_equal 200, page.status_code

    click_on 'Continue'

    assert_equal 200, page.status_code
    assert_content 'Item name:'
    assert_content 'stone knife'
    assert_content '1 hour'
    assert_element 'form', action: "#{host}/en/projects"
  end

  test 'show project setup page for project outside' do
    recipe = create(:recipe, recipe_type: Recipe::VEHICLE, base_speed: 14_400,
                             key: 'small_wooden_cart')
    create(:project_type, :build)

    visit "/en/recipes?expanded[]=#{recipe.id}"

    assert_equal 200, page.status_code

    click_on 'Continue'

    assert_equal 200, page.status_code
    assert_content 'Item name:'
    assert_content 'small wooden cart'
    assert_content '2 hours'
    assert_content 'Can be build only outside the buildings/vehicles'
    assert_element 'form', action: "#{host}/en/projects"
  end

  test 'show options for needed items' do
    v_small_shaft = create(:item_type, key: 'small_shaft', virtual: true)
    create(:item_type, key: 'small_wooden_shaft',
                       parent_item_type: v_small_shaft)
    create(:item_type, key: 'small_bone_shaft',
                       parent_item_type: v_small_shaft)
    recipe = create(:recipe, recipe_type: Recipe::MACHINERY, base_speed: 14_400,
                             key: 'drop_spindle')
    create(:recipe_instruction, :item, recipe: recipe, subject: v_small_shaft)
    create(:project_type, :build)

    visit "/en/recipes?expanded[]=#{recipe.id}"

    assert_equal 200, page.status_code

    assert_content 'drop spindle'
    assert_content 'small bone shaft'
    assert_content 'small wooden shaft'
    assert_no_content 'small shaft'
  end

  test 'show options for needed tools' do
    knife = create(:item_type, key: 'knife', virtual: true)
    create(:item_type, key: 'steel_knife',
                       parent_item_type: knife)
    create(:item_type, key: 'bone_knife',
                       parent_item_type: knife)
    recipe = create(:recipe, recipe_type: Recipe::ITEM, base_speed: 14_400,
                             key: 'small_wooden_shaft')
    create(:recipe_instruction, :tool, recipe: recipe, subject: knife)
    create(:project_type, :build)

    visit "/en/recipes?expanded[]=#{recipe.id}"

    assert_equal 200, page.status_code

    assert_content 'steel knife'
    assert_content 'bone knife'
    assert_content 'small wooden shaft'
  end
end
