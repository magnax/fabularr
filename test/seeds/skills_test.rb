# frozen_string_literal: true

require 'test_helper'

class SeedsSkillsTest < ActiveSupport::TestCase
  def setup
    Skill.destroy_all
  end

  test 'works' do
    assert_difference -> { Skill.count } => 27 do
      require_relative '../../db/seeds/skills'
    end
  end
end
