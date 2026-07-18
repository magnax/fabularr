# frozen_string_literal: true

require 'test_helper'

class SeedsProjectTypesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { ProjectType.count } => 6 do
      require_relative '../../db/seeds/project_types'
    end

    keys = %w[build collect create_location discover_resource machinery road]
    assert_equal keys.sort, ProjectType.pluck(:key).sort
  end

  def teardown
    ProjectType.destroy_all
  end
end
