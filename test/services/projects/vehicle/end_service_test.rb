# frozen_string_literal: true

require 'test_helper'

class ProjectsVehicleEndServiceTest < ActiveSupport::TestCase
  def call_service(project_id)
    Projects::EndService.call(project_id)
  end

  test 'creates vehicle in location' do
    location = create(:location)
    create(:location_type, key: 'small_wooden_cart')
    create(:location_class, key: 'vehicle')

    wood = create(:resource, :material, key: 'wood')
    recipe = create(:recipe, recipe_type: 'vehicle',
                             key: 'small_wooden_cart', base_speed: 3600)
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
                                            metadata: { name: 'My Cart' })
    create(:worker, project: project, character: starting_character)

    assert_difference -> { Location.count } => 1,
                      -> { Event.count } => 1 do
      call_service(project.id)
    end

    assert_equal 1, location.reload.vehicles.length

    new_vehicle = Vehicle.last
    assert_equal location.coords, new_vehicle.coords
    assert_equal 1.1, new_vehicle.metadata['base_speed']
    assert_equal 'My Cart', new_vehicle.name

    event = Event.last
    assert_equal 'Project started by you has just ended. Manufactured: small wooden cart',
                 event.body
  end
end
