# frozen_string_literal: true

require 'test_helper'

class ProjectsLeaveServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(project_id)
    Projects::LeaveService.call(@character, project_id)
  end

  test 'leaves project' do
    project = create(:project, :discover_resource)
    worker = create(:worker, project: project, character: @character)

    assert_difference -> { Worker.count } => 0 do
      call_service(project.id)
    end

    assert worker.reload.left_at
  end
end
