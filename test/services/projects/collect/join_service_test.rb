# frozen_string_literal: true

require 'test_helper'

class ProjectsJoinServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(project_id)
    Projects::JoinService.call(@character, project_id)
  end

  test 'set speed for worker when joining with tool' do
    recipe = create(:recipe, recipe_type: 'collect')
    instruction = create(:recipe_instruction, :tool,
                         recipe: recipe, speed: 2)
    project = create(:project, :collect, recipe: recipe)
    tool = create(:item, item_type: instruction.subject)
    create(:inventory_object, character: @character, subject: tool)

    assert_difference -> { Worker.count } => 1 do
      call_service(project.id)
    end

    worker = Worker.last
    assert_equal @character.id, worker.character_id
    assert_equal instruction.speed, worker.speed
  end

  test 'set proper speed if character has multiple tools' do
    recipe = create(:recipe, recipe_type: 'collect')
    instruction_1 = create(:recipe_instruction, :tool,
                           recipe: recipe, speed: 1.5)
    instruction_2 = create(:recipe_instruction, :tool,
                           recipe: recipe, speed: 2)
    project = create(:project, :collect, recipe: recipe)
    tool_1 = create(:item, item_type: instruction_1.subject)
    tool_2 = create(:item, item_type: instruction_2.subject)
    create(:inventory_object, character: @character, subject: tool_1)
    create(:inventory_object, character: @character, subject: tool_2)

    assert_difference -> { Worker.count } => 1 do
      call_service(project.id)
    end

    worker = Worker.last
    assert_equal @character.id, worker.character_id
    assert_equal instruction_2.speed, worker.speed
  end
end
