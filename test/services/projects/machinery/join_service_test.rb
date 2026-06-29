# frozen_string_literal: true

require 'test_helper'

class ProjectsMachineryJoinServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(project_id)
    Projects::JoinService.call(@character, project_id)
  end

  test 'can join to project and reveal skill' do
    skill = create(:skill, key: Skill::MANUFACTURING_MACHINES)
    recipe = create(:recipe, skill: skill)
    project = create(:project, :machinery, recipe: recipe)

    assert_equal 0, @character.character_skills.visible.count

    assert_difference -> { Worker.count } => 1 do
      call_service(project.id)
    end

    assert_equal 1, @character.reload.character_skills.visible.count
    assert @character.character_skills.find_by(skill_id: skill.id).status
  end
end
