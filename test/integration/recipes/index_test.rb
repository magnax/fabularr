# frozen_string_literal: true

require 'test_helper'

class RecipesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    sign_in
    click_link 'Magnus'
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end

  test 'no recipes available' do
    visit '/en/recipes'

    assert_equal 200, page.status_code
    assert_content 'Available formulas: 0'
  end

  test 'show available recipes: items, buildings, vehicles' do
    create(:recipe, recipe_type: Recipe::BUILDING, key: 'wood_shack')
    create(:recipe, recipe_type: Recipe::ITEM, key: 'stone_knife')
    create(:recipe, recipe_type: Recipe::VEHICLE, key: 'small_wooden_cart')
    create(:recipe, recipe_type: Recipe::COLLECT, key: 'wood')

    visit '/en/recipes'

    assert_equal 200, page.status_code
    assert_content 'Available formulas: 3'
    assert_content 'stone knife'
    assert_content 'wood shack'
    assert_content 'small wooden cart'
  end

  test 'show project setup page for given recipe' do
    create(:recipe, recipe_type: Recipe::ITEM, base_speed: 7200, key: 'stone_knife')
    create(:project_type, :build)

    visit '/en/recipes'

    assert_equal 200, page.status_code

    click_on 'Continue'

    assert_equal 200, page.status_code
    assert_content 'Item name:'
    assert_content 'stone knife'
    assert_content '1 hour'
    assert_element 'form', action: "#{host}/en/projects"
  end
end
