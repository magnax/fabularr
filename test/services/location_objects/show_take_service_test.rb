# frozen_string_literal: true

require 'test_helper'

class LocationObjectsShowTakeServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location)
    @character = create(:character, location: @location)
  end

  def call_service(location_object_id)
    LocationObjects::ShowTakeService.call(@character, location_object_id)
  end

  test 'raise error when invalid location object' do
    assert_raise LocationObjects::InvalidObjectError do
      call_service(0)
    end
  end

  test 'raise error when character is in different location' do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @location, subject: iron,
                                             amount: 200)
    @character.update!(location: create(:location))

    assert_raise LocationObjects::InvalidObjectError do
      call_service(location_iron.id)
    end
  end

  test 'returns resource info' do
    iron = create(:resource, key: 'iron')
    location_iron = create(:location_object, location: @location, subject: iron,
                                             amount: 200)

    res = call_service(location_iron.id)

    assert_equal iron.id, res[:subject_id]
    assert_equal 200, res[:amount]
    assert_equal 'iron', res[:key]
    assert_equal 'grams', res[:unit]
    assert_equal 'Resource', res[:subject_type]
  end
end
