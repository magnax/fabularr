# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id                 :integer          not null, primary key
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  location_type_id   :integer
#  locationclass_id   :integer
#  parent_location_id :integer
#
require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test 'model fields' do
    location = build(:location)

    assert_respond_to location, :location_type_id
    assert_respond_to location, :characters
    assert_respond_to location, :visible_characters
    assert_respond_to location, :hearable_characters

    assert location.valid?
  end
end
