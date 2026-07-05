# frozen_string_literal: true

require 'test_helper'

class ProjectsCollectNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)

    create(:project_type, key: 'collect')

    sign_in(@user)
    click_link 'Magnus'
  end

  def teardown
    Resource.destroy_all
  end

  test 'no recipes available' do
    wood = create(:resource, key: 'wood', daily_rate: 600)
    location_resource = create(:location_resource, resource: wood,
                                                   location: @character.location)
    visit "/en/projects/new/collect/#{location_resource.id}"

    assert_equal 200, page.status_code
    assert_content 'One character can collect only 600 grams in one day'
  end

  test 'show proper skill name - digging' do
    digging = create(:skill, key: Skill::DIGGING)
    stone = create(:resource, key: 'stone', daily_rate: 600, skill: digging)
    location_resource = create(:location_resource, resource: stone,
                                                   location: @character.location)

    visit "/en/projects/new/collect/#{location_resource.id}"

    assert_equal 200, page.status_code
    assert_selector 'div[class="title-bar"]', text: 'digging for stone'
    assert_content 'One character can dig only 600 grams in one day'
  end

  test 'when there are recipes with tools' do
    wood = create(:resource, key: 'wood', daily_rate: 600)
    location_resource = create(:location_resource, resource: wood,
                                                   location: @character.location)
    recipe = create(:recipe, recipe_type: 'collect', key: 'wood')
    stone_knife = create(:item_type, key: 'stone_knife')
    stone_axe = create(:item_type, key: 'stone_axe')
    create(:recipe_instruction, :tool, recipe: recipe, speed: 1.2, subject: stone_knife)
    create(:recipe_instruction, :tool, recipe: recipe, speed: 2, subject: stone_axe)

    visit "/en/projects/new/collect/#{location_resource.id}"

    assert_equal 200, page.status_code
    assert_content 'One character can collect only 600 grams in one day'
    assert_content 'stone knife, you can collect 720 grams in one day'
    assert_content 'stone axe, you can collect 1200 grams in one day'
  end
end
