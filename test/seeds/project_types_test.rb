# frozen_string_literal: true

require 'test_helper'

class SeedsProjectTypesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { ProjectType.count } => 3 do
      require_relative '../../db/seeds/project_types'
    end
  end
end
