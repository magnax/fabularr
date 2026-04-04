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
    assert_respond_to location, :hearable_characters
    assert_respond_to location, :x
    assert_respond_to location, :y

    assert location.valid?
  end

  test 'read coordinates' do
    location = build(:location, coords: '23.5,55.8')

    assert_equal 23.5, location.x
    assert_equal 55.8, location.y
  end

  test 'display_name' do
    location = create(:location, name: 'Fabular City')
    building = create(:location, :building, parent_location: location, name: 'Town Hall')

    assert_equal 'Fabular City', location.display_name
    assert_equal 'Fabular City', location.display_name(parent: true)
    assert_equal 'Town Hall', building.display_name
    assert_equal 'Fabular City (Town Hall)', building.display_name(parent: true)
  end
end
