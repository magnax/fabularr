# frozen_string_literal: true

require 'test_helper'

class SeedsSkillsTest < ActiveSupport::TestCase
  TEST_SKILL_COUNT = 27

  def setup
    Skill.destroy_all
  end

  test 'works' do
    assert_difference -> { Skill.count } => TEST_SKILL_COUNT do
      Seeds::Skills.call
    end
  end

  test 'does not create the same skill when called twice' do
    assert_difference -> { Skill.count } => TEST_SKILL_COUNT do
      Seeds::Skills.call
      Seeds::Skills.call
    end
  end
end
