# frozen_string_literal: true

require 'test_helper'

class SeedsLocationsTest < ActiveSupport::TestCase
  test 'works' do
    create(:user)

    assert_difference -> { Location.count } => 10 do
      Seeds::Skills.call
      Seeds::RawResources.call
      Seeds::Locations.call
    end

    Location.find_each do |location|
      assert_not_empty location.location_resources
      assert_empty location.location_resources.visible
    end
  end

  def teardown
    Resource.destroy_all
    CharacterSkill.destroy_all
    Skill.destroy_all
  end
end
