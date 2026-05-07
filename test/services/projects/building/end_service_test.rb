# frozen_string_literal: true

require 'test_helper'

class ProjectsBuildingEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test '#build/building creates building in location' do
    location = create(:location)
    create(:location_type, key: 'wood_shack')
    create(:location_class, key: 'building')

    wood = create(:resource, :material, key: 'wood')
    recipe = create(:recipe, recipe_type: 'building', key: 'wood_shack', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: wood,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')

    starting_character = create(:character, location: location)
    project = create(:project, :build, location: location,
                                       starting_character: starting_character,
                                       recipe: recipe)
    create(:project_description, project: project, subject: wood, amount: 100,
                                 unit: 'grams')
    create(:project_description, :settings, project: project, subject: nil,
                                            metadata: { name: 'Town Hall' })
    create(:worker, project: project, character: starting_character)

    assert_difference -> { InventoryObject.count } => 0,
                      -> { Location.count } => 1 do
      call_service(project.id)
    end

    assert_equal 1, location.reload.buildings.length

    new_location = Location.last
    assert_equal location.coords, new_location.coords
    assert_equal 'Town Hall', new_location.name
  end
end
