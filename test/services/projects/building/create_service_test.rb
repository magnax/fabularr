# frozen_string_literal: true

require 'test_helper'

class ProjectsBuildingCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'building - just material' do
    project_type = create(:project_type, key: 'build',
                                         base_speed: 0, fixed: true)
    wood = create(:resource, :material, key: 'wood')
    recipe = create(:recipe, recipe_type: 'building', key: 'wood_shack', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: wood,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id,
      name: 'Town Hall'
    }

    assert_difference(
      -> { Project.count } => 1,
      -> { ProjectDescription.count } => 2
    ) do
      call_service(params)
    end

    pd = ProjectDescription.where(description_type: 'settings').sole
    assert_equal 'Town Hall', pd.metadata['name']
  end
end
