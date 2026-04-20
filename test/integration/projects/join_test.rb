# frozen_string_literal: true

require 'test_helper'

class ProjectsJoinTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@user, @character)
  end

  test 'join project' do
    project_type = create(:project_type, key: 'discover_resource',
                                         base_speed: 1000, fixed: true)
    project = create(:project, project_type: project_type)

    assert_difference -> { Worker.count }, 1 do
      get "/projects/#{project.id}/join"
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end
end
