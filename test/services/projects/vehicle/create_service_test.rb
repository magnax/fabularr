# frozen_string_literal: true

require 'test_helper'

class ProjectsVehicleCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'vehicle - just material' do
    project_type = create(:project_type, key: 'build',
                                         base_speed: 0, fixed: true)
    wood = create(:resource, :material, key: 'wood')
    recipe = create(:recipe, recipe_type: 'vehicle', key: 'small_wooden_cart', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: wood,
                                amount: 500, unit: 'grams',
                                instruction_type: 'resource')

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id,
      name: 'My Cart'
    }

    assert_difference(
      -> { Project.count } => 1,
      -> { ProjectDescription.count } => 2,
      -> { Event.count } => 1
    ) do
      call_service(params)
    end

    pd = ProjectDescription.where(description_type: 'settings').sole
    assert_equal 'My Cart', pd.metadata['name']

    event = Event.last
    assert_equal "You're starting new project: building new vehicle (small wooden cart).",
                 event.body
  end

  test 'vehicle - error when started inside the building' do
    building = create(:location, :building)
    @current_character.update!(location: building)
    project_type = create(:project_type, key: 'build')
    recipe = create(:recipe, recipe_type: 'vehicle')

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id
    }

    assert_raises Projects::OnlyOutsideError do
      call_service(params)
    end
  end
end
