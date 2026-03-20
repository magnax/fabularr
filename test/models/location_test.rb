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
