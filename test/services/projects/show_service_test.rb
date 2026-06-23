# frozen_string_literal: true

require 'test_helper'

class ProjectsShowServiceTest < ActiveSupport::TestCase
  def setup
    GameTime.create!(created_at: 30.days.ago)
    @character = create(:character, name: 'Magnus')
  end

  def call_service(project_id)
    Projects::ShowService.call(@character, project_id)
  end

  test 'collecting' do
    skill = create(:skill, key: Skill::DIGGING)
    second_character = create(:character)
    create(:character_skill, character: second_character, skill: skill,
                             level: 0.4)
    create(:character_skill, character: @character, skill: skill,
                             level: 3.2)
    stone = create(:resource, key: 'stone', skill: skill)
    project = create(:project, :collect, amount: 300, elapsed: 100, duration: 200,
                                         starting_character: @character)
    create(:project_description, :resource_out, project: project, subject: stone)
    create(:worker, project: project, character: @character)
    create(:worker, project: project, character: second_character)
    create(:worker, project: project, character: @character, left_at: 1.hour.ago)

    res = call_service(project.id)

    assert_equal 'digging for stone', res[:name]
    assert_equal 300, res[:amount]
    assert_equal 'Magnus', res[:starting_character_name]
    assert_equal @character.id, res[:starting_character_id]
    assert_equal '30-0', res[:start_day]
    assert_equal 2, res[:participants].length
    assert_equal [@character.id, second_character.id].sort,
                 res[:participants].pluck(:id).sort
    assert_equal ['Magnus', 'unknown man'],
                 res[:participants].pluck(:name).sort
    assert_equal %w[awkwardly skillfully],
                 res[:participants].pluck(:skill).sort
    assert_equal 50, res[:progress]
    assert_equal '1 hour', res[:time]
    assert_equal 'hand', res[:run_type]
  end
end
