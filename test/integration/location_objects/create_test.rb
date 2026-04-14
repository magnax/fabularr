# frozen_string_literal: true

require 'test_helper'

class LocationObjectsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, location: @location, user: @user)
    login(@character)
  end

  test '#create' do
    stone = create(:resource, key: 'stone')
    create(:inventory_object, character: @character,
                              subject: stone, amount: 100)

    params = {
      location_object: {
        subject_id: stone.id,
        subject_type: 'Resource',
        amount: '50'
      }
    }

    assert_difference -> { LocationObject.count } => 1 do
      post '/location_objects', params: params
    end

    assert_response :found

    assert_redirected_to '/en/events'
  end
end
