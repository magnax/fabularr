# frozen_string_literal: true

require 'test_helper'

class SeedsSkillsTest < ActiveSupport::TestCase
  def setup
    Skill.destroy_all
  end

  test 'works' do
    assert_difference -> { Skill.count } => 27 do
      Seeds::Skills.call
    end
  end
end
