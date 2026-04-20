# frozen_string_literal: true

require 'test_helper'

class ProjectsLeaveTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    login(@user, @character)
  end

  test 'leave project' do
    project_type = create(:project_type, key: 'discover_resource',
                                         base_speed: 1000, fixed: true)
    project = create(:project, project_type: project_type)
    worker = create(:worker, character: @character, project: project, left_at: nil)

    assert_difference -> { Worker.count }, 0 do
      get "/projects/#{project.id}/leave"
    end

    assert_response :found

    assert_redirected_to '/en/events'
    assert_not_nil worker.reload.left_at
  end
end
