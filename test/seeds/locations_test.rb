# frozen_string_literal: true

require 'test_helper'

class SeedsLocationsTest < ActiveSupport::TestCase
  test 'works' do
    create(:user)

    assert_difference -> { Location.count } => 10 do
      require_relative '../../db/seeds/raw_resources'
      require_relative '../../db/seeds/locations'
    end

    Location.find_each do |location|
      assert_not_empty location.location_resources
      assert_empty location.location_resources.visible
    end
  end
end
