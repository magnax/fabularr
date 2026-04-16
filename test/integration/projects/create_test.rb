# frozen_string_literal: true

require 'test_helper'

class ProjectsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@character)
  end

  test 'create project' do
    project_type = create(:project_type, key: 'discover_resource',
                                         base_speed: 1000, fixed: true)
    params = {
      project: {
        project_type_id: project_type.id
      }
    }

    assert_difference -> { Project.count }, 1 do
      post '/projects', params: params
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end
end
