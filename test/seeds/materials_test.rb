# frozen_string_literal: true

require 'test_helper'

class SeedsMaterialsTest < ActiveSupport::TestCase
  test 'works' do
    expected_count = 3

    assert_difference -> { Resource.count } => expected_count,
                      -> { ResourceType.count } => 2 do
      require_relative '../../db/seeds/materials'
    end

    assert_equal expected_count, Resource.material.count

    # check some resources for proper values
    wood = Resource.find_by(key: 'wood')
    assert_equal 0, wood.daily_rate
    assert_equal 2, wood.resource_types.length
    assert_equal %w[fuel material], wood.resource_types.pluck(:key).sort
  end
end
