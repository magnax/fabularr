# frozen_string_literal: true

require 'test_helper'

class SeedsProjectTypesTest < ActiveSupport::TestCase
  test 'works' do
    ProjectType.destroy_all

    assert_difference -> { ProjectType.count } => 6 do
      Seeds::ProjectTypes.call
    end

    keys = %w[build collect create_location discover_resource machinery road]
    assert_equal keys.sort, ProjectType.pluck(:key).sort
  end
end
