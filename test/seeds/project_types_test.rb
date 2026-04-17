# frozen_string_literal: true

require 'test_helper'

class SeedsProjectTypesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { ProjectType.count } => 4 do
      require_relative '../../db/seeds/project_types'
    end

    keys = %w[build collect create_location discover_resource]
    assert_equal keys.sort, ProjectType.pluck(:key).sort
  end
end
