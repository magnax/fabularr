# frozen_string_literal: true

require 'test_helper'

class ProjectsCreateLocationCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character, coords: { x: 120, y: 140 })
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'start creating a new location' do
    project_type = create(:project_type, key: 'create_location',
                                         base_speed: 1000, fixed: true)
    params = {
      project_type_id: project_type.id
    }

    assert_difference -> { Project.count } => 1,
                      -> { ProjectDescription.count } => 1 do
      call_service(params)
    end

    project = Project.last

    assert_equal 1000, project.duration
    assert_equal 0, project.elapsed
    assert project.ready
    assert_equal 'Creating new location', project.short_name
    assert_equal "Creating new location, started by: #{@current_character.name}",
                 project.name(@current_character)

    pd = ProjectDescription.last
    assert_equal ProjectDescription::LOCATION, pd.description_type
    coords = { 'x' => 120.0, 'y' => 140.0 }
    assert_equal coords, pd.metadata['coords']
  end
end
