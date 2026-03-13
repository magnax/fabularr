# frozen_string_literal: true

require 'test_helper'

class ProjectsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'discover new location resource' do
    project_type = create(:project_type, key: 'discover_resource',
                                         base_speed: 1000, fixed: true)
    params = {
      project_type_id: project_type.id
    }

    assert_difference -> { Project.count }, 1 do
      call_service(params)
    end

    project = Project.last

    assert_equal 1000, project.duration
    assert_equal 0, project.elapsed
  end

  test 'collect resource' do
    project_type = create(:project_type, key: 'collect',
                                         base_speed: 6, fixed: false)
    strawberry = create(:resource, :raw_food, key: 'strawberries')
    location_resource = create(:location_resource, location: @location,
                                                   resource: strawberry)

    params = {
      project_type_id: project_type.id,
      location_resource_id: location_resource.id,
      amount: '100'
    }

    assert_difference -> { Project.count }, 1 do
      call_service(params)
    end

    project = Project.last

    assert_equal 'collect', project.project_type.key
    assert_equal 600, project.duration
    assert_equal 0, project.elapsed

    desc = ProjectDescription.last
    assert_equal strawberry.id, desc.subject_id
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_OUT, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 100, desc.amount_needed
    assert_equal 'grams', desc.unit

    event = Event.last
    assert_equal "You're starting new project: collecting strawberries.", event.body
  end

  test 'build' do
    project_type = create(:project_type, key: 'build',
                                         base_speed: 0, fixed: true)
    stone = create(:resource, :raw_food, key: 'stone')
    recipe = create(:recipe, key: 'stone_knife', base_speed: 3600)
    create(:recipe_instruction, recipe: recipe, subject: stone,
                                amount: 100, unit: 'grams',
                                instruction_type: 'resource')

    params = {
      project_type_id: project_type.id,
      recipe_id: recipe.id
    }

    assert_difference(
      -> { Project.count } => 1,
      -> { ProjectDescription.count } => 1
    ) do
      call_service(params)
    end

    project = Project.last

    assert_equal 'build', project.project_type.key
    assert_equal 3600, project.duration
    assert_equal 0, project.elapsed

    desc = ProjectDescription.last
    assert_equal stone.id, desc.subject_id
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_IN, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 100, desc.amount_needed
    assert_equal 'grams', desc.unit

    # event = Event.last
    # assert_equal "You're starting new project: collecting strawberries.", event.body
  end
end
