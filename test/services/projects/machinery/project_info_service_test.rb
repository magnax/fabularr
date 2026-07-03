# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryProjectInfoServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @project_type = create(:project_type, key: ProjectType::MACHINERY)
    @cooking = create(:skill, key: Skill::COOKING)
  end

  def teardown
    Resource.destroy_all
    Skill.destroy_all
  end

  def call_service(params)
    Projects::ProjectInfoService.call(@character, params)
  end

  test 'raise exception for invalid machine' do
    params = {
      project: {
        machine_id: 0
      },
      type: 'machine'
    }

    assert_raises Projects::Info::Machine::InvalidMachineError do
      call_service(params)
    end
  end

  test 'proper data for recipe' do
    pit = create(:machinery, key: 'small_fire_pit')
    meat = create(:resource, :raw_food, key: 'meat')
    dung = create(:resource, :raw_resource, key: 'dried_dung')
    grilled_meat = create(:resource, :food, key: 'grilled_meat')
    recipe = create(:recipe, skill: @cooking, key: 'grilled_meat_dung',
                             recipe_type: 'grilling')
    create(:recipe_instruction, recipe: recipe, subject: meat, amount: 250)
    create(:recipe_instruction, recipe: recipe, subject: dung, amount: 150)
    create(:recipe_instruction, :resource_out, recipe: recipe,
                                               subject: grilled_meat, amount: 275)
    create(:recipe_instruction, :machinery, recipe: recipe, subject: pit)
    create(:recipe_instruction, :max_amount, recipe: recipe, subject: nil, amount: 18_000)
    machine = create(:location_object, subject: pit, location: @character.location)
    create(:inventory_object, character: @character, subject: meat, amount: 33)

    params = {
      project: {
        machine_id: machine.id
      },
      recipe_id: recipe.id,
      type: 'machine'
    }

    res = call_service(params)

    assert_equal 275, res[:daily_amount]
    assert_equal 18_000, res[:max_amount]
    assert_equal 'grilled meat', res[:resource_out]
    assert_equal 2, res[:resources_in].length

    resources_in = res[:resources_in].pluck(:needed)
    assert_includes resources_in, '250 grams meat'
    assert_includes resources_in, '150 grams dried dung'

    assert_equal %w[dried_dung meat], res[:resources_in].pluck(:key).sort

    amounts_in = res[:resources_in].pluck(:having)
    assert_includes amounts_in, 0
    assert_includes amounts_in, 33
  end
end
