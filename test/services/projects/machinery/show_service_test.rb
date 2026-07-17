# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryShowServiceTest < ActiveSupport::TestCase
  def setup
    GameTime.create!(created_at: 30.days.ago)
    @location = create(:location)
    @character = create(:character, name: 'Magnus', location: @location)
    @skill = create(:skill, key: Skill::COOKING)

    @pit = create(:machinery, key: 'small_fire_pit')
    @machine = create(:location_object, subject: @pit, location: @location)

    @meat = create(:resource, :raw_food, key: 'meat')
    @dung = create(:resource, :raw_resource, key: 'dried_dung')
    @grilled_meat = create(:resource, :food, key: 'grilled_meat')
  end

  def call_service(project_id)
    Projects::ShowService.call(@character, project_id)
  end

  def create_recipe!
    @recipe = create(:recipe, key: 'grilled_meat_dung', recipe_type: Recipe::GRILLING,
                              skill: @skill)
    create(:recipe_instruction, recipe: @recipe, subject: @meat, amount: 250)
    create(:recipe_instruction, recipe: @recipe, subject: @dung, amount: 150)
    create(:recipe_instruction, :resource_out, recipe: @recipe,
                                               subject: @grilled_meat, amount: 225)
    create(:recipe_instruction, :machinery, recipe: @recipe, subject: @pit)
    create(:recipe_instruction, :max_amount, recipe: @recipe, subject: nil, amount: 18_000)
  end

  test 'show needed/used resources' do
    create_recipe!

    create(:character_skill, character: @character, skill: @skill,
                             level: 3.2)
    project = create(:project, :machinery, amount: 300, elapsed: 100, duration: 200,
                                           starting_character: @character, recipe: @recipe)

    create(:project_description, :resource_out, project: project, subject: @grilled_meat, amount: 300)
    create(:project_description, :resource_in,
           project: project, subject: @meat, amount: 300, amount_needed: 600)
    create(:project_description, :resource_in,
           project: project, subject: @dung, amount: 0, amount_needed: 500)
    create(:worker, project: project, character: @character)
    create(:worker, project: project, character: @character, left_at: 1.hour.ago)

    res = call_service(project.id)

    assert_equal 'grilling meat', res[:name]
    assert_includes res[:resources_used], { key: 'meat', to_add: 300, needed: 600 }
    assert_includes res[:resources_used], { key: 'dried dung', to_add: 500, needed: 500 }
    assert_equal ['not all resources added'], res[:problems]
  end
end
