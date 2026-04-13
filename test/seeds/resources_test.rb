# frozen_string_literal: true

require 'test_helper'

class SeedsResourcesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { Resource.count } => 10 do
      require_relative '../../db/seeds/resources'
    end
  end
end
