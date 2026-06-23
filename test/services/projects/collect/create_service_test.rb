# frozen_string_literal: true

require 'test_helper'

class ProjectsCollectCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
    @project_type = create(:project_type, key: 'collect')
  end

  def call_service(params)
    Projects::CreateService.call(
      @current_character, params.merge(project_type_id: @project_type.id)
    )
  end

  test 'raises invalid resource exception' do
    strawberry = create(:resource, :raw_food, key: 'strawberries', daily_rate: 600)
    location_resource = create(:location_resource, location: @location, status: false,
                                                   resource: strawberry)

    params = {
      location_resource_id: location_resource.id,
      amount: 600
    }

    assert_raises Projects::Create::Collect::InvalidResourceError do
      call_service(params)
    end
  end

  test 'collect resource' do
    strawberry = create(:resource, :raw_food, key: 'strawberries', daily_rate: 600)
    location_resource = create(:location_resource, location: @location,
                                                   resource: strawberry)

    params = {
      location_resource_id: location_resource.id,
      amount: 600
    }

    assert_difference -> { Project.count }, 1 do
      call_service(params)
    end

    project = Project.last

    assert_equal 'collect', project.project_type.key
    assert_equal 86_400, project.duration
    assert_equal 0, project.elapsed
    assert project.ready

    desc = ProjectDescription.last
    assert_equal strawberry.id, desc.subject_id
    assert_equal 'Resource', desc.subject_type
    assert_equal ProjectDescription::RESOURCE_OUT, desc.description_type
    assert_equal 0, desc.amount
    assert_equal 600, desc.amount_needed
    assert_equal 'grams', desc.unit

    event = Event.last
    assert_equal "You're starting new project: collecting strawberries.", event.body
  end

  test 'collect resource, repeating project' do
    strawberry = create(:resource, :raw_food, key: 'strawberries', daily_rate: 600)
    location_resource = create(:location_resource, location: @location,
                                                   resource: strawberry)

    params = {
      location_resource_id: location_resource.id,
      amount: 600,
      repeat: 3
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 2 do
      call_service(params)
    end

    project = Project.last

    assert_equal 'collect', project.project_type.key
    assert_equal 86_400, project.duration
    assert_equal 0, project.elapsed
    assert project.ready

    desc = ProjectDescription.where(
      description_type: ProjectDescription::RESOURCE_OUT
    ).sole
    assert_equal strawberry.id, desc.subject_id
    assert_equal 'Resource', desc.subject_type
    assert_equal 0, desc.amount
    assert_equal 600, desc.amount_needed
    assert_equal 'grams', desc.unit

    desc = ProjectDescription.where(
      description_type: ProjectDescription::REPEAT
    ).sole
    assert_equal 3, desc.amount

    event = Event.last
    assert_equal "You're starting new project: collecting strawberries.", event.body
  end
end
