# frozen_string_literal: true

require 'test_helper'

class SeedsRawResourcesTest < ActiveSupport::TestCase
  test 'works' do
    expected_count = 80

    assert_difference -> { Resource.count } => expected_count,
                      -> { ResourceType.count } => 4 do
      require_relative '../../db/seeds/raw_resources'
    end

    assert_equal %w[fuel medicine raw_food raw_resource], ResourceType.pluck(:key).sort
    assert_equal expected_count, Resource.raw_resource.count

    # check some resources for proper values
    # healing
    apples = Resource.find_by(key: 'apples')
    assert_equal 100, apples.base_speed_per_unit
    assert_equal 88, apples.heal
    assert_equal 0, apples.eaten
    assert_equal %w[medicine raw_resource], apples.resource_types.pluck(:key).sort
    assert_equal 'forestry', apples.skill.key

    # nourishing food example
    carrots = Resource.find_by(key: 'carrots')
    assert_equal 800, carrots.base_speed_per_unit
    assert_equal 0, carrots.heal
    assert_equal 250, carrots.eaten
    assert_equal %w[raw_food raw_resource], carrots.resource_types.pluck(:key).sort
    assert_equal 'farming', carrots.skill.key
  end
end
