# frozen_string_literal: true

require 'test_helper'

class ProjectsDiscoverResourceCreateServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
    @project_type = create(:project_type, key: 'discover_resource',
                                          base_speed: 1000, fixed: true)
  end

  def call_service
    Projects::CreateService.call(@character, { project_type_id: @project_type.id })
  end

  test 'discover new location resource' do
    assert_difference -> { Project.count }, 1 do
      call_service
    end

    project = Project.last

    assert_equal 1000, project.duration
    assert_equal 0, project.elapsed
    assert project.ready
  end
end
