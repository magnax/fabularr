# frozen_string_literal: true

require 'test_helper'

class SeedsSkillsTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { Skill.count } => 26 do
      require_relative '../../db/seeds/skills'
    end
  end

  def teardown
    Skill.destroy_all
  end
end
