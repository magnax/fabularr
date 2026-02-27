# frozen_string_literal: true

require 'test_helper'

class ProjectsCreateServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character)
    @project_type = create(:project_type, key: 'discover_resource',
                                          base_speed: 1000, fixed: true)
  end

  def call_service(params)
    Projects::CreateService.call(@current_character, params)
  end

  test 'discover new location resource' do
    params = {
      project_type_id: @project_type.id
    }

    assert_difference -> { Project.count }, 1 do
      call_service(params)
    end

    project = Project.last

    assert_equal 1000, project.duration
    assert_equal 0, project.elapsed
  end
end
