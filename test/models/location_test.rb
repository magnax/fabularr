# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id                 :integer          not null, primary key
#  coords             :point
#  max_capacity       :integer
#  max_characters     :integer
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  location_class_id  :bigint
#  location_type_id   :integer
#  parent_location_id :integer
#
# Indexes
#
#  index_locations_on_location_class_id  (location_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_class_id => location_classes.id)
#
require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test 'model fields' do
    location = build(:location)

    assert_respond_to location, :location_type_id
    assert_respond_to location, :coords

    assert location.valid?
  end

  test 'model methods' do
    location = build(:location)

    assert_respond_to location, :characters
    assert_respond_to location, :visible_characters
    assert_respond_to location, :x
    assert_respond_to location, :y

    assert location.valid?
  end

  test 'read coordinates' do
    location = build(:location, coords: '23.5,55.8')

    assert_equal 23.5, location.x
    assert_equal 55.8, location.y
  end

  test 'default name for town location' do
    location = create(:location, name: 'Fabular City')

    assert_equal 'unnamed place', location.default_name
  end

  test 'default name for building' do
    location = create(:location, name: 'Fabular City')
    building = create(:location, :building, parent_location: location, name: 'Town Hall')

    assert_equal 'Town Hall', building.default_name
  end

  test 'display_name for character' do
    location = create(:location, name: 'Fabular City')
    building = create(:location, :building, parent_location: location, name: 'Town Hall')
    character1 = create(:character)
    character2 = create(:character)
    character3 = create(:character)
    character4 = create(:character)

    create(:location_name, character: character2, location: location, name: 'Some Place')
    create(:location_name, character: character2, location: building, name: 'Some Building')

    create(:location_name, character: character3, location: location, name: 'My Place')

    create(:location_name, character: character4, location: building, name: 'My Building')

    # character has no remembered names
    assert_equal 'unnamed place', location.display_name(character1)
    assert_equal 'unnamed place', location.display_name(character1, parent: true)
    assert_equal 'Town Hall', building.display_name(character1)
    assert_equal 'unnamed place (Town Hall)', building.display_name(character1, parent: true)

    # character has all names remembered
    assert_equal 'Some Place', location.display_name(character2)
    assert_equal 'Some Place', location.display_name(character2, parent: true)
    assert_equal 'Some Building', building.display_name(character2)
    assert_equal 'Some Place (Some Building)', building.display_name(character2, parent: true)

    # character has remembered only town name, not building
    assert_equal 'My Place (Town Hall)', building.display_name(character3, parent: true)

    # character has remembered only building name, not town
    assert_equal 'unnamed place (My Building)', building.display_name(character4, parent: true)
  end
end
