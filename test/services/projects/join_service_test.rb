require 'test_helper'

class ProjectsJoinServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(project_id)
    Projects::JoinService.call(@character, project_id)
  end

  test 'raises exception on invalid project' do
    assert_raise Projects::JoinService::ProjectNotFoundError do
      call_service(0)
    end
  end

  test 'can join to project (no requirements)' do
    project = create(:project, :discover_resource)

    assert_difference -> { Worker.count } => 1 do
      call_service(project.id)
    end
  end

  test 'cannot join to project without needed tools' do
    recipe = create(:recipe)
    create(:recipe_instruction, :tool, recipe: recipe)
    project = create(:project, :build, recipe: recipe)

    assert_difference -> { Worker.count } => 0 do
      call_service(project.id)
    end
  end

  test 'can join to project when has all needed tools' do
    recipe = create(:recipe)
    instruction = create(:recipe_instruction, :tool, recipe: recipe)
    project = create(:project, :build, recipe: recipe)
    tool = create(:item, item_type: instruction.subject)
    create(:inventory_object, character: @character, subject: tool)

    assert_difference -> { Worker.count } => 1 do
      call_service(project.id)
    end
  end
end
