# frozen_string_literal: true

require 'test_helper'

class SeedsRawResourcesTest < ActiveSupport::TestCase
  TEST_RESOURCE_COUNT = 80
  TEST_RESOURCE_TYPE_COUNT = 4

  def setup
    Resource.destroy_all
    Skill.destroy_all
  end

  test 'works' do
    assert_difference -> { Resource.count } => TEST_RESOURCE_COUNT,
                      -> { ResourceType.count } => TEST_RESOURCE_TYPE_COUNT do
      Seeds::RawResources.call
    end

    assert_equal %w[fuel medicine raw_food raw_resource], ResourceType.pluck(:key).sort
    assert_equal TEST_RESOURCE_COUNT, Resource.raw_resource.count

    # check some resources for proper values
    # healing
    apples = Resource.find_by(key: 'apples')
    assert_equal 100, apples.daily_rate
    assert_equal 88, apples.heal
    assert_equal 0, apples.eaten
    assert_equal %w[medicine raw_resource], apples.resource_types.pluck(:key).sort
    assert_equal 'forestry', apples.skill.key

    # nourishing food example
    carrots = Resource.find_by(key: 'carrots')
    assert_equal 800, carrots.daily_rate
    assert_equal 0, carrots.heal
    assert_equal 250, carrots.eaten
    assert_equal %w[raw_food raw_resource], carrots.resource_types.pluck(:key).sort
    assert_equal 'farming', carrots.skill.key
  end

  test 'does not create the same records when called twice' do
    assert_difference -> { Resource.count } => TEST_RESOURCE_COUNT,
                      -> { ResourceType.count } => TEST_RESOURCE_TYPE_COUNT do
      Seeds::RawResources.call
      Seeds::RawResources.call
    end
  end
end
