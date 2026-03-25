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

  test 'only build recipes available' do
    create(:recipe, recipe_type: 'build', key: 'stone_knife')
    create(:recipe, recipe_type: 'collect', key: 'wood')

    visit '/en/recipes'

    assert_equal 200, page.status_code
    assert_content 'Available formulas: 1'
    assert_content 'stone knife'
  end
end
