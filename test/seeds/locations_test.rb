# frozen_string_literal: true

require 'test_helper'

class SeedsLocationsTest < ActiveSupport::TestCase
  test 'works' do
    create(:user)

    assert_difference -> { Location.count } => 10 do
      require_relative '../../db/seeds/locations'
    end
  end
end
